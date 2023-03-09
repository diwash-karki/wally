import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:wally/UI/search_field.dart';
import 'UI/Category.dart';
import 'API/pixabay.dart';
import 'Model/splashModel.dart';
import 'UI/imagecard.dart';
import 'dart:async';
import 'Screen/preview.dart';

void main() {
  runApp(const Homepage());
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController searchController = TextEditingController();
  final String secretCode = 'your api code';
  Pixabay spalsh = Pixabay();
  bool isState = false;
  List<Map<String, dynamic>> images = [];
  int dropdownvalue = 2;
  List<int> items = [1, 2, 3, 4];
  String queryTitle = "Recent Uploads";
  Timer? _debounce;
  Future<List<Map<String, dynamic>>> load() async {
    if (!isState) {
      final value = await spalsh.getImages();
      List<dynamic> res = json.decode(value.body)['hits'];
      List<Map<String, dynamic>> result = SplashModel.fromJson(res).toJson();
      images = {...result}.toList();
      isState = true;
      return images;
    }
    return {...images}.toList();
  }

  loadMore() async {
    final value = await spalsh.loadPage();

    List<dynamic> res = json.decode(value.body)['hits'];
    List<Map<String, dynamic>> result = SplashModel.fromJson(res).toJson();
    if (result.length > 2) {
      result.remove(result[0]);
      result.remove(result[0]);
    }

    images = {...images, ...result}.toList();
    setState(() {});
  }

  void searchImage(String searchText) async {
    // Cancel any previous debounce timer
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    // Schedule a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      final value = await spalsh.getImagesBySearch(searchText);
      List<dynamic> res = [];
      try {
        res = json.decode(value.body)['hits'];
      } catch (e) {
        res = json.decode(value.body)['hits'];
      }
      List<Map<String, dynamic>> result = SplashModel.fromJson(res).toJson();
      images = {...result}.toList();
      if (searchText.trim() == "") {
        queryTitle = "Recent Uploads";
      } else {
        queryTitle = "Search Results for $searchText";
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    searchController.dispose();
    super.dispose();
  }

  @override
  initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    spalsh.setSecretCode(secretCode);
    super.initState();
  }

  SizedBox gap({double height = 1}) {
    return SizedBox(
      height: 1.h * height,
    );
  }

  List<String> categoryList = [
    'Landscape',
    'Sunset',
    'Car',
    'Anime',
    'Flower',
    'Marvel',
    'Technology',
    'Building',
    'Animal',
    'Dark'
  ];

  void selectCategory(int index) {
    setState(() {});
    if (index >= 0) {
      searchImage(categoryList[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() => searchImage(searchController.text));
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                gap(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "EXPLORE",
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 7.w,
                    ),
                  ),
                ),
                gap(height: 5),
                searchField(searchController),
                gap(height: 5),
                Container(
                  width: 95.w,
                  padding: const EdgeInsets.only(bottom: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "CATEGORY",
                    style: TextStyle(
                      fontSize: 4.w,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                categoryHolder(context, selectCategory),
                gap(height: 4),
                SizedBox(
                  width: 95.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          queryTitle,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                            fontSize: 4.w,
                          ),
                        ),
                      ),
                      Container(
                        width: 25.w,
                        height: 5.h,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1.0,
                                style: BorderStyle.solid,
                                color: Color.fromARGB(88, 0, 0, 0)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          value: dropdownvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((int items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items.toString()),
                            );
                          }).toList(),
                          onChanged: (int? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                gap(height: 2.5),
                FutureBuilder(
                  future: load(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if (snapshot.data!.isNotEmpty) {
                        return SizedBox(
                          width: 97.w,
                          child: GridView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: dropdownvalue,
                            ),
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PreviewScreen(
                                              url: snapshot.data![index]
                                                  ['image'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: imageCard(
                                          snapshot.data![index]['thumbnail']),
                                    )),
                          ),
                        );
                      } else {
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: const Text("No Data Found"),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Center(
                  child: InkWell(
                    onTap: loadMore,
                    child: Container(
                      width: 30.w,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "LOAD MORE",
                        style: TextStyle(
                          fontSize: 3.w,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }));
  }
}

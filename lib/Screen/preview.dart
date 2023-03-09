import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.url});

  final String url;
  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  Icon done = const Icon(Icons.done, color: Colors.white);
  Icon wallpaper = const Icon(Icons.wallpaper, color: Colors.white);
  Icon download = const Icon(Icons.download, color: Colors.white);
  Icon currentW = const Icon(Icons.wallpaper, color: Colors.white);
  Icon currentD = const Icon(Icons.download, color: Colors.white);
  Dio dio = Dio();
  void setWallpaper(url) async {
    try {
      await AsyncWallpaper.setWallpaper(
        url: url,
        wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        goToHome: false,
      ).then((_) {
        currentW = done;
        setState(() {});
      });
    } catch (e) {
      currentW = wallpaper;
    }
  }

  void downloadImage(url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/myfile.jpg';

      await dio.download(url, path);
      await GallerySaver.saveImage(path).then((value) {
        currentD = done;
        setState(() {});
      });
    } catch (e) {
      currentD = download;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: Container(
            height: 100.h,
            width: 100.w,
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.url),
                    onError: (exception, stackTrace) => const Icon(Icons.error),
                    fit: BoxFit.cover)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => setWallpaper(widget.url),
                  child: Container(
                    height: 6.h,
                    width: 6.h,
                    margin: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(85, 0, 0, 0),
                    ),
                    child: currentW,
                  ),
                ),
                GestureDetector(
                  onTap: (() => downloadImage(widget.url)),
                  child: Container(
                      height: 6.h,
                      width: 6.h,
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(85, 0, 0, 0),
                      ),
                      child: currentD),
                )
              ],
            ),
          ),
        ),
      );
    }));
  }
}

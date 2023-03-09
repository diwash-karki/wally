import 'package:http/http.dart';

class Pixabay {
  String url =
      "https://pixabay.com/api/?image_type=photo&order=latest&orientation=vertical&key=";
  String page = "1";
  String secret = '';
  String perpage = "10";
  Pixabay({String secretcode = "None", page = "1", String perpage = "10"});

  void setSecretCode(String code) {
    secret = code;
  }

  Future<Response> getImages() async {
    url = "https://pixabay.com/api/?image_type=photo&order=popular&key=";
    String urls =
        "$url$secret&per_page=$perpage&page=$page&orientation=vertical";
    Response response = await get(Uri.parse(urls));
    return response;
  }

  Future<Response> getImagesBySearch(String query) async {
    page = "1";
    url =
        "https://pixabay.com/api/?image_type=photo&q=${Uri.encodeComponent(query)}&key=";
    String urls = "$url$secret&per_page=$perpage&orientation=vertical";
    Response response = await get(Uri.parse(urls));
    return response;
  }

  Future<Response> getImagesByCategory(String category) async {
    String urls =
        "$url$secret&per_page=$perpage&page=$page&orientation=vertical&oder=popular&q=$category";
    Response response = await get(Uri.parse(urls));
    return response;
  }

  Future<Response> loadPage() async {
    page = (int.parse(page) + 1).toString();
    String urls =
        "$url$secret&per_page=$perpage&page=$page&order=popular&orientation=vertical";
    Response response = await get(Uri.parse(urls));
    return response;
  }
}

// ignore: file_names
class SplashModel {
  String thumbnail = '';
  String image = '';
  List<Map<String, dynamic>> results = [];
  SplashModel({this.thumbnail = '', this.image = '', this.results = const []});

  SplashModel.fromJson(List<dynamic> json) {
    for (Map<String, dynamic> item in json) {
      thumbnail = item['webformatURL'];
      image = item['largeImageURL'];
      results.add({'thumbnail': thumbnail, 'image': image});
    }
  }

  List<Map<String, dynamic>> toJson() {
    return results;
  }
}

// integrating with https://dog.ceo/dog-api

import 'dart:convert' as convert;
//import 'dart:ffi';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getDogBreeds() async {
  var url = Uri.https('dog.ceo', '/api/breeds/list/all', {'q': '{https}'});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResponse["message"];
  }

  // todo: error handling

  return <String, dynamic>{};
}

Future<List<String>> getDogSubBreeds(String breed) async {
  var url = Uri.https('dog.ceo', '/api/breed/$breed/list', {'q': '{https}'});
  var response = await http.get(url);
  List<String> subBreeds = [];

  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    for (var element in (jsonResponse["message"] as List<dynamic>)) {
      subBreeds.add(element.toString());
    }
  }

  // todo: error handling

  return subBreeds;
}

Future<String> getRandomImage() async {
  var url = Uri.https('dog.ceo', '/api/breeds/image/random', {'q': '{https}'});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    return jsonResponse["message"];
  }

  // todo: error handling

  return "";
}

Future<List<String>> getImagesByBreed(String breed) async {
  var breedImages = <String>[];
  var url = Uri.https('dog.ceo', '/api/breed/$breed/images/', {'q': '{https}'});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    List<dynamic> imageUrls = jsonResponse["message"];

    for (var imageUrl in imageUrls) {
      breedImages.add(imageUrl.toString());
    }
  }

  // todo: error handling

  return breedImages;
}

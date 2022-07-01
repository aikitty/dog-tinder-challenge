import 'dart:convert' as convert;
//import 'dart:ffi';
import 'package:http/http.dart' as http;

// Note to self: this is for building the filter drop down for breed and sub breed
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

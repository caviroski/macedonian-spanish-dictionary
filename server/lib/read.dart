import 'dart:convert';
import 'dart:io';

class Read {

  static final Read _singleton = Read._internal();
  var jsonPath = File('../assets/dictionary.json');
  List<dynamic> dictionaryJson;
  
  factory Read() {
    return _singleton;
  }

  Read._internal();

  Future readJsonFile() async {
    var jsonText = '';

    final lines = utf8.decoder
      .bind(jsonPath.openRead())
      .transform(const LineSplitter());
    try {
      await for (var line in lines) {
        jsonText = jsonText + line;
      }
      dictionaryJson = jsonDecode(jsonText);
      return dictionaryJson;
    } catch (_) {
      print('err1or: $_');
    }
  }

}
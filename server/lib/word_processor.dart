import 'package:server/read.dart';

class WordProcessor {

  static final WordProcessor _singleton = WordProcessor._internal();
  var read = Read();

  factory WordProcessor() {
    return _singleton;
  }

  WordProcessor._internal();

  String encodeDecodeWord(String word) {
    // Needed because shelf has problems with óéí characters
    var decodeWord = Uri.decodeQueryComponent(word);
    var translation = findWordInDictionary(decodeWord);
    if (translation == null) {
      return 'noword';
    }
    return Uri.encodeQueryComponent(translation);
  }

  String findWordInDictionary(String word) {
    String translation;

    for (var i = 0; i < read.dictionaryJson.length; i++) {
      if (read.dictionaryJson[i]['mkd'] == word) {
        translation = read.dictionaryJson[i]['esp'];
        break;
      }
    }

    return translation;
  }

}
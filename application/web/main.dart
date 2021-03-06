import 'dart:html';

void main() {
  querySelector('.translate-button').onClick.listen(onTranslateClick); 
}

void onTranslateClick(MouseEvent event) {
  var wordForTranslation = (querySelector('.word-input') as InputElement).value;
  checkInput(wordForTranslation);
}

void checkInput(String word) {
  var input = querySelector('.translation-display') as InputElement;
  if (word == '') {
    input.value = 'Please enter word';
  } else if (isCyrillicWord(word)) {
    getTranslatedWord(word);
  } else if (!isWord(word)) {
    input.value = 'Only words accepted';
  } else if (isWord(word)) {
    input.value = 'Only Macedonian Cyrillic words accepted';
  }
}

bool isWord(String word) {
  return RegExp(r'^[a-zA-Z]+$').hasMatch(word);
}

bool isCyrillicWord(String word) {
  return RegExp(r'^[аАбБвВгГдДѓЃеЕжЖзЗѕЅиИјЈкКлЛљЉмМнНњЊоОпПрРсСтТќЌуУфФхХцЦчЧџЏшШ]+$').hasMatch(word);
}

void getTranslatedWord(String word) {
  var httpRequest = HttpRequest();
  httpRequest.open('GET', 'http://localhost:4500/word/$word');
  httpRequest.onLoadEnd.listen((e) => loadEnd(httpRequest));
  httpRequest.send();
}

void loadEnd(HttpRequest httpRequest) {
  var input = querySelector('.translation-display') as InputElement;
  print('DONE ${httpRequest.response}');
  if (httpRequest.response == 'noword') {
    input.value = 'No translation for this word';
  } else {
    var decodeWord = Uri.decodeQueryComponent(httpRequest.response);
    input.value = decodeWord;
  }
}

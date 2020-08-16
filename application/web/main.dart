import 'dart:html';

void main() {
  querySelector('.translate-button').onClick.listen(onTranslateClick); 
}

void onTranslateClick(MouseEvent event) {
  var wordForTranslation = (querySelector('.word-input') as InputElement).value;
  checkInput(wordForTranslation);
}

void checkInput(String word) {
  if (word == '') {
    (querySelector('.translation-display') as InputElement).value = 'Please enter word';
  } else if (isCyrillicWord(word)) {
    print('translate');
  } else if (!isWord(word)) {
    (querySelector('.translation-display') as InputElement).value = 'Only words accepted';
  } else if (isWord(word)) {
    (querySelector('.translation-display') as InputElement).value = 'Only Macedonian Cyrillic words accepted';
  }
}

bool isWord(String word) {
  return RegExp(r'^[a-zA-Z]+$').hasMatch(word);
}

bool isCyrillicWord(String word) {
  return RegExp(r'^[аАбБвВгГдДѓЃеЕжЖзЗѕЅиИјЈкКлЛљЉмМнНњЊоОпПрРсСтТќЌуУфФхХцЦчЧџЏшШ]+$').hasMatch(word);
}

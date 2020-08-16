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
    print('translate');
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

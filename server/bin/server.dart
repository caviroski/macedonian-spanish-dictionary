import 'dart:io';
import 'dart:convert';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

var jsonPath = File('../assets/dictionary.json');
List<dynamic> dictionaryJson;

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);
  var app = Router();

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '4500';
  var port = int.tryParse(portStr);

  await readJsonFile().then(
    (aaa) => print('ddd $aaa')
  );


  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  app.get('/word/<word>', (shelf.Request request, String word) {
    var response = encodeDecodeWord(word);  
    return shelf.Response.ok('Translated word is $response');
  });

  var server = await io.serve(app.handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

String encodeDecodeWord(String word) {
  // Needed because shelf has problems with óéí characters
  var decodeWord = Uri.decodeQueryComponent(word);
  var translation = findWordInDictionary(decodeWord);
  return Uri.encodeQueryComponent(translation);
}

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

String findWordInDictionary(String word) {
  String translation;

  for (var i = 0; i < dictionaryJson.length; i++) {
    if (dictionaryJson[i]['mkd'] == word) {
      translation = dictionaryJson[i]['esp'];
      break;
    }
  }

  return translation;
}

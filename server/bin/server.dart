import 'dart:io';
import 'dart:convert';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

var jsonPath = File('../assets/dictionary.json');
var dictionaryJson = '';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);
  var app = Router();
  var aaa = 22;

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '4500';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  app.get('/hello', (shelf.Request request) {
    return shelf.Response.ok('hello-world');
  });

  app.get('/', (shelf.Request request) {
    return shelf.Response.ok('hello-world $aaa');
  });

  var server = await io.serve(app.handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
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
  } catch (_) {
    print('error: $_');
  }
}

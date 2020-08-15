import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'package:server/read.dart';
import 'package:server/word_processor.dart';

// For Google Cloud Run, set _hostname to '0.0.0.0'.
const _hostname = 'localhost';

void main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);
  var app = Router();
  var read = Read();
  var wordProcessor = WordProcessor();

  // For Google Cloud Run, we respect the PORT environment variable
  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '4500';
  var port = int.tryParse(portStr);

  await read.readJsonFile().then(
    (aaa) => print('ddd $aaa')
  );

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  app.get('/word/<word>', (shelf.Request request, String word) {
    var response = wordProcessor.encodeDecodeWord(word);  
    return shelf.Response.ok('Translated word is $response');
  });

  var server = await io.serve(app.handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

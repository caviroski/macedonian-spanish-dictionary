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
  final _headers = {'Access-Control-Allow-Origin': '*', 'Content-Type': 'text/html'};

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

  shelf.Response _options(shelf.Request request) => (request.method == 'OPTIONS')?
    shelf.Response.ok(null, headers: _headers) : null;
  shelf.Response _cors(shelf.Response response) => response.change(headers: _headers);
  var _fixCORS = shelf.createMiddleware(requestHandler: _options, responseHandler: _cors);

  app.get('/word/<word>', (shelf.Request request, String word) {
    var response = wordProcessor.encodeDecodeWord(word);
    return shelf.Response.ok('$response');
  });

  final handler = const shelf.Pipeline()
  .addMiddleware(_fixCORS)
  .addMiddleware(shelf.logRequests())
  .addHandler(app.handler);

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

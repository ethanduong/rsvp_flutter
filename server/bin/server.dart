import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  // DB Configuration: Use environment variable DATA_DIR or default local. 
  // Extremely important for mounting persistent docker volumes.
  final dataDir = Platform.environment['DATA_DIR'] ?? '.';
  final dbPath = '$dataDir/wedding.db';
  print('Loading database from: $dbPath');
  final db = sqlite3.open(dbPath);
  
  // Initialize Database Schema
  db.execute('''
    CREATE TABLE IF NOT EXISTS RsvpResponse (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      guestName TEXT NOT NULL,
      message TEXT,
      attendance TEXT NOT NULL,
      partySize INTEGER NOT NULL DEFAULT 1,
      side TEXT NOT NULL,
      submittedAt INTEGER NOT NULL,
      updatedAt INTEGER NOT NULL
    );
  ''');

  db.execute('''
    CREATE TABLE IF NOT EXISTS SiteConfig (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL
    );
  ''');
  
  final router = Router();

  router.post('/api/rsvp', (Request request) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);
    
    final stamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    final stmt = db.prepare('''
      INSERT INTO RsvpResponse (guestName, message, attendance, partySize, side, submittedAt, updatedAt)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''');
    
    stmt.execute([
      data['guestName'],
      data['message'],
      data['attendance'],
      data['partySize'] ?? 1,
      data['side'],
      stamp,
      stamp
    ]);
    
    return Response.ok(jsonEncode({'success': true}), headers: {'Content-Type': 'application/json'});
  });

  Middleware _corsMiddleware() {
    return (innerHandler) {
      return (request) async {
        if (request.method == 'OPTIONS') {
          return Response.ok('', headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Origin, Content-Type',
          });
        }
        final response = await innerHandler(request);
        return response.change(headers: {
          'Access-Control-Allow-Origin': '*',
        });
      };
    };
  }

  final apiHandler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsMiddleware())
      .addHandler(router.call);

  // Fallback handler for the compiled Flutter UI
  final flutterWebPath = Platform.environment['WEB_DIR'] ?? '../frontend/build/web';
  final uiHandler = createStaticHandler(flutterWebPath, defaultDocument: 'index.html');

  // Cascade the router: First check /api routes, otherwise serve UI files
  final cascade = Cascade().add(apiHandler).add(uiHandler);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(cascade.handler, InternetAddress.anyIPv4, port);
  print('Serving at http://${server.address.host}:${server.port}');
}

String jsonEncodeRows(ResultSet rows) {
  final list = <Map<String, dynamic>>[];
  for (final row in rows) {
    list.add(row);
  }
  return jsonEncode(list);
}

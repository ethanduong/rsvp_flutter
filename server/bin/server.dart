import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('wedding.db');
  
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
  
  final app = Router();

  app.post('/api/rsvp', (Request request) async {
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



  // CORS Middleware
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware((innerHandler) {
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
      })
      .addHandler(app.call);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server listening on port \${server.port}');
}

String jsonEncodeRows(ResultSet rows) {
  final list = <Map<String, dynamic>>[];
  for (final row in rows) {
    list.add(row);
  }
  return jsonEncode(list);
}

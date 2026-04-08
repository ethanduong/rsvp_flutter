import 'dart:convert';
import 'package:http/http.dart' as http;

class RsvpService {
  final String baseUrl = 'http://localhost:8080/api';

  Future<bool> submitRsvp(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rsvp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Error submitting RSVP: $e');
      return false;
    }
  }


}

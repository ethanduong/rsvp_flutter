import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class RsvpService {
  Future<bool> submitRsvp(Map<String, dynamic> data) async {
    try {
      final baseUrl = kReleaseMode ? '' : 'http://localhost:8080';
      final response = await http.post(
        Uri.parse('$baseUrl/api/rsvp'),
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

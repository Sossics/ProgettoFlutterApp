import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:flutter_application_app/Constants/AuthenticationApiConstants.dart';

class ApiService {
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  Future<Map<String, dynamic>?> postRequest(String url, Map<String, dynamic> body) async {
    try {
      print("REQUEST URL: " + url);
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      print("Errore nella richiesta POST: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRequest(String url) async {
    try {
      print("REQUEST URL: " + url);
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      print("Errore nella richiesta GET: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> putRequest(String url, Map<String, dynamic> body) async {
      print("REQUEST URL: " + url);
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      print("Errore nella richiesta PUT: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteRequest(String url) async {
    try {
      print("REQUEST URL: " + url);
      final response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      print("Errore nella richiesta DELETE: $e");
      return null;
    }
  }

  Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Errore HTTP ${response.statusCode}: ${response.body}");
      return null;
    }
  }
}
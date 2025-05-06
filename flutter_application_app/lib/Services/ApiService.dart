import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:flutter_application_app/Constants/AuthenticationApiConstants.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'dart:async';
import 'package:xml2json/xml2json.dart';

class ApiService {
  final StorageService _StorageService = StorageService();
  String? TOKEN = "Bearer ";
  late Map<String, String> headers;
  final Completer<void> _initCompleter = Completer<void>();

  Future<void> get ready => _initCompleter.future;

  ApiService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      TOKEN = 'Bearer ' + (await _StorageService.getToken() ?? '');
      print("TOKEN: $TOKEN");
      headers = {'Content-Type': 'application/json', 'Authorization': TOKEN!};
      _initCompleter.complete();
    } catch (e) {
      print("Errore durante _initialize: $e");
      _initCompleter.completeError(
        e,
      ); // <-- importante per evitare attese infinite
    }
  }

  Future<void> _waitUntilReady() async {
    await _initCompleter.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw Exception('ApiService non inizializzato in tempo'),
    );
  }

  Future<Map<String, dynamic>?> postRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    await _waitUntilReady();
    try {
      print("REQUEST URL: POST " + url);
      print("REQUEST Headers: " + headers.toString());
      print("REQUEST Body: " + body.toString());
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
    await _waitUntilReady();
    try {
      print("REQUEST URL: GET " + url);
      print("REQUEST Headers: " + headers.toString());
      final response = await http.get(Uri.parse(url), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      print("Errore nella richiesta GET: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> putRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    await _waitUntilReady();
    print("REQUEST URL: PUT " + url);
    print("REQUEST Headers: " + headers.toString());
    print("REQUEST Body: " + body.toString());
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

  Future<Map<String, dynamic>?> patchRequest(
    String url,
    Map<String, dynamic> body,
  ) async {
    await _waitUntilReady();
    print("REQUEST URL: PATCH " + url);
    print("REQUEST Headers: " + headers.toString());
    print("REQUEST Body: " + body.toString());
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      print("Errore nella richiesta PATCH: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteRequest(String url) async {
    await _waitUntilReady();
    try {
      print("REQUEST URL: DEL " + url);
      print("REQUEST Headers: " + headers.toString());
      final response = await http.delete(Uri.parse(url), headers: headers);
      return _handleResponse(response);
    } catch (e) {
      print("Errore nella richiesta DELETE: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> _handleResponse(http.Response response) async {
    print("Server Response: ${response.body}");
    if (response.statusCode == 200) {
      if(await _StorageService.getMod() == "json"){
        return jsonDecode(response.body);
      }else if(await _StorageService.getMod() == "xml"){

        //-------------------------------------------------------------   DA VEDERE   ----------------------

          Future<Map<String, dynamic>> convertXmlToJson(String xmlResponse) async {
            final Xml2Json xml2json = Xml2Json();
            xml2json.parse(xmlResponse);
            final jsonString = xml2json.toParker();
            final Map<String, dynamic> json = jsonDecode(jsonString);

            // Controlla se il contenitore "result" esiste e restituisci il contenuto interno
            if (json.containsKey('result')) {
              final result = json['result'];
              print("\n\n\njson: $result");
              return result;
            } else {
              print("\n\n\njson: $json");
              return json;
            }
          }

         return await convertXmlToJson(response.body);

      }
    } else {
      print("Errore HTTP ${response.statusCode}: ${response.body}");
      return null;
    }
  }
}

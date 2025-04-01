import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/ApiService.dart';
import 'package:flutter_application_app/Constants/ApiConstants.dart';
import 'package:flutter_application_app/Screen/HomeScreen.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await _apiService.postRequest(ApiConstants.loginEndpoint, {
      "email": email,
      "password": password,
    });

    if (response != null && response.containsKey('token')) {
      print("Login riuscito: ${response['message']}");

      // Naviga alla HomeScreen dopo il login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print("Errore di login");

      // Mostra un messaggio di errore con uno SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenziali errate. Riprova.")),
      );
    }
  }

  Future<void> register(
    BuildContext context,
    String email,
    String password,
  ) async {
    final response = await _apiService.postRequest(
      ApiConstants.registerEndpoint,
      {"email": email, "password": password},
    );

    if (response != null && response.containsKey('token')) {
      print("Registrazione riuscita: ${response['message']}");

      // Naviga alla HomeScreen dopo la registrazione
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      print("Errore di registrazione");

      // Mostra un messaggio di errore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrazione fallita. Riprova.")),
      );
    }
  }
}

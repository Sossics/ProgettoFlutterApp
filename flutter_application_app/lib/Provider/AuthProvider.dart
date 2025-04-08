import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/ApiService.dart';
import 'package:flutter_application_app/Services/TokenStorageService.dart';
import 'package:flutter_application_app/Constants/AuthenticationApiConstants.dart';
import 'package:flutter_application_app/Screen/HomeScreen.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    print("Signing in...");
    print("Using Endpoint: ${AuthenticationApiConstants.loginEndpoint}");
    final response = await _apiService.postRequest(AuthenticationApiConstants.loginEndpoint, {
      "email": email,
      "password": password,
    });

    if (response != null && response.containsKey('token')) {
      print("Login riuscito: ${response['message']}");
      print("Token: ${response['token']}");
      print("Username: ${response['username']}");
      print("Email: ${response['email']}");
      print("Salvo il token nella memoria...");
      await _tokenStorageService.saveToken(response['token']);
      print("Token salvato con successo.");

      // Naviga alla HomeScreen
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
    String name,
    String surname,
    String email,
    String password,
    String username
  ) async {
    print("Signing on...");
    print("Using Endpoint: ${AuthenticationApiConstants.registerEndpoint}");
    final response = await _apiService.postRequest(
      AuthenticationApiConstants.registerEndpoint,
      {"email": email, "password": password, "username": username, "name": name, "surname": surname},
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

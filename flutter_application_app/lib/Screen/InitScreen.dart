import 'package:flutter/material.dart';
import 'package:flutter_application_app/Screen/WelcomeScreen.dart';
import 'package:flutter_application_app/Screen/HomeScreen.dart';
import 'package:flutter_application_app/Services/TokenStorageService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final StorageService _StorageService = StorageService();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final token = await _StorageService.getToken();

    if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      // Token valido → vai alla Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Token non presente o scaduto → vai al welcome/login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

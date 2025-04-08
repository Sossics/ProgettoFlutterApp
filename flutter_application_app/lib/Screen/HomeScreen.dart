import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/TokenStorageService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TokenStorageService _tokenStorageService = TokenStorageService();
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // Carica il token all'avvio
  _loadToken() async {
    String? token = await _tokenStorageService.getToken();
    setState(() {
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Benvenuto!"),
              const SizedBox(height: 20),
              Text(_token ?? "Token non disponibile"),
            ],
          ),
        ),
      ),
    );
  }
}

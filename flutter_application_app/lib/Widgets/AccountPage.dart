import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:flutter_application_app/Screen/WelcomeScreen.dart';

class AccountPage extends StatelessWidget {
  final StorageService _StorageService = StorageService();

  Future<void> _logout(BuildContext context) async {
    await _StorageService.deleteToken();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(  // Aggiungiamo il Center per centrare il contenuto orizzontalmente e verticalmente
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centro il contenuto verticalmente
          crossAxisAlignment: CrossAxisAlignment.center,  // Centro il contenuto orizzontalmente
          children: [
            // Titolo
            const Text(
              "Account",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Benvenuto nella tua area personale.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

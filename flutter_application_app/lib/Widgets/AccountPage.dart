import 'package:flutter/material.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:flutter_application_app/Screen/WelcomeScreen.dart';
import 'package:flutter_application_app/Widgets/NotesPage.dart';
import 'package:flutter_application_app/Constants/HTTPmode.dart';

class AccountPage extends StatelessWidget {
  final StorageService _StorageService = StorageService();

  Future<void> _logout(BuildContext context) async {
    await _StorageService.changeMod();
    await _StorageService.deleteToken();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Aggiungiamo il Center per centrare il contenuto orizzontalmente e verticalmente
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centro il contenuto verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centro il contenuto orizzontalmente
          children: [
            // Titolo
            const Text(
              "Account",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Benvenuto nella tua area personale.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.black,
                ), // Cambia il colore del testo in nero
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(
                  15,
                ), // Rende il bottone un quadrato
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    Future<HTTPMode?> futureMod = _StorageService.getMod();
                    return ElevatedButton(
                      onPressed: () async {
                        await _StorageService.changeMod();
                        setState(() {
                          futureMod = _StorageService.getMod();
                        });
                      },
                      child: FutureBuilder<HTTPMode?>(
                        future: futureMod,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text("Error");
                          } else {
                            return Text(
                              snapshot.data?.value ?? "Default",
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            );
                          }
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          111,
                          169,
                          10,
                          209,
                        ),
                        padding: const EdgeInsets.all(
                          15,
                        ), // Rende il bottone un quadrato
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Screen/WelcomeScreen.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  final StorageService _StorageService = StorageService();

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController? _nameController;
  TextEditingController? _surnameController;
  int? uid;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<AppProvider>();
      await provider.fetchUser();

      final user = provider.user;
      if (user != null && user.isNotEmpty) {
        setState(() {
          uid = int.tryParse(user[0]['userID'].toString());
          _nameController = TextEditingController(text: user[0]['name'] ?? '');
          _surnameController = TextEditingController(text: user[0]['surname'] ?? '');
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _surnameController?.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    widget._StorageService.setMod();
    await widget._StorageService.deleteToken();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
    );
  }

  Future<void> _modifify(BuildContext context) async {
    if (uid == null) return;

    final appProvider = context.read<AppProvider>();
    final successUpdate = await appProvider.updateUser(
      uid!,
      _nameController!.text,
      _surnameController!.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(successUpdate
            ? "User updated successfully"
            : "Error during update"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final user = appProvider.user;

    if (_nameController == null || _surnameController == null || user == null || user.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const Text("Nome", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: "Inserisci il tuo nome",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Cognome", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(
                hintText: "Inserisci il tuo cognome",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _modifify(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 187, 38, 241),
                padding: const EdgeInsets.all(15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Salva", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Logout", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ElevatedButton(
                      onPressed: () async {
                        await widget._StorageService.changeMod();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(111, 169, 10, 209),
                        padding: const EdgeInsets.all(15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: FutureBuilder<String?>(
                        future: widget._StorageService.getMod(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text("Error");
                          } else {
                            return Text(
                              snapshot.data ?? "Default",
                              style: const TextStyle(color: Colors.black),
                            );
                          }
                        },
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

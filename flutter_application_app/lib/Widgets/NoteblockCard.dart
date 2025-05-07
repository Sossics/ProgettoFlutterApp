// lib/Widgets/NoteCard.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_app/Widgets/NoteblockEditPage.dart'; // Importa la nuova pagina di modifica

class NoteblockCard extends StatelessWidget {
  final String id; // Aggiungi una proprietà per l'ID
  final String title;
  final String body;

  const NoteblockCard({
    super.key,
    required this.id, // Modifica il costruttore per ricevere l'ID
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: () {
          // Naviga alla pagina di modifica della nota passando i dati
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteblockEditPage(noteblockId: int.parse(id), title: title, body: body),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 8),
              Text(body,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

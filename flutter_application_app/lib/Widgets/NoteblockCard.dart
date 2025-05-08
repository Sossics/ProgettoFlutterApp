import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteblockEditPage.dart';
import 'package:flutter_application_app/Widgets/NoteblockDetailsPage.dart'; // Da creare

class NoteblockCard extends StatelessWidget {
  final String id;
  final String title;
  final String body;

  const NoteblockCard({
    super.key,
    required this.id,
    required this.title,
    required this.body,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Conferma eliminazione"),
        content: const Text("Sei sicuro di voler eliminare questo blocco note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final provider = context.read<AppProvider>();
              final success = await provider.deleteNotepad(int.parse(id));
              if (success) {
                await provider.fetchNotepads();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Errore durante l'eliminazione")),
                );
              }
            },
            child: const Text("Elimina", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _goToEditPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NoteblockEditPage(noteblockId: int.parse(id), title: title, body: body),
      ),
    );
    if (result == true && context.mounted) {
      await context.read<AppProvider>().fetchNotepads();
    }
  }

  void _goToDetailsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteblockDetailsPage( // Da implementare
          noteblockId: int.parse(id),
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _goToDetailsPage(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: "Modifica",
                    onPressed: () => _goToEditPage(context),
                  ),
                  ElevatedButton(
                    onPressed: () => _confirmDelete(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      elevation: 0,
                    ),
                    child: const Text("Delete", style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                body,
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

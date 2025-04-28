import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    // Carica le note una volta che la pagina è stata inizializzata
    Future.microtask(() => context.read<AppProvider>().fetchNotes());
  }

  @override
  Widget build(BuildContext context) {
    // Ottieni lo stato dal provider
    final appProvider = context.watch<AppProvider>();
    
    if (appProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appProvider.hasError) {
      return const Center(child: Text('Errore nel caricamento delle note.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appProvider.notes.length,
      itemBuilder: (context, index) {
        final note = appProvider.notes[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(note['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(note['body'] ?? ''),
          ),
        );
      },
    );
  }
}

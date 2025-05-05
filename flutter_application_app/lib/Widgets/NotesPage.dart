import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteCard.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppProvider>().fetchNotes());
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    if (appProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appProvider.hasError) {
      return const Center(child: Text('Errore nel caricamento delle note.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final notes = appProvider.notes;

        if (!isWide) {
          // Mobile layout
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                id: note['id'] ?? '0',
                title: note['title'] ?? 'No Title',
                body: note['body'] ?? '',
              );
            },
          );
        } else {
          // Wide screen layout
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1000) crossAxisCount = 3;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                id: note['id'] ?? '0',
                title: note['title'] ?? 'No Title',
                body: note['body'] ?? '',
              );
            },
          );
        }
      },
    );
  }
}

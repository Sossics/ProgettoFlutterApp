import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteCard.dart';
import 'package:flutter_application_app/Widgets/NoteEditPage.dart';
import 'package:flutter_application_app/Widgets/CreateNotePage.dart';

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

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final notes = appProvider.notes;

          if (!isWide) {
            // Mobile layout with 2 columns
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => NoteEditPage(
                              noteId: int.parse(note['id'] ?? '0'),
                              title: note['title'] ?? '',
                              body: note['body'] ?? '',
                            ),
                      ),
                    );

                    if (updated == true && context.mounted) {
                      await context.read<AppProvider>().fetchNotes();
                    }
                  },
                );
              },
            );
          } else {
            // Wide screen layout
            int crossAxisCount = 2;
            if (constraints.maxWidth > 1000 && constraints.maxWidth < 1500)
              crossAxisCount = 3;
            if (constraints.maxWidth > 1500) crossAxisCount = 4;

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
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => NoteEditPage(
                              noteId: int.parse(note['id'] ?? '0'),
                              title: note['title'] ?? '',
                              body: note['body'] ?? '',
                            ),
                      ),
                    );

                    if (updated == true && context.mounted) {
                      await context.read<AppProvider>().fetchNotes();
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNotePage()),
          );

          if (result == true && context.mounted) {
            context.read<AppProvider>().fetchNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

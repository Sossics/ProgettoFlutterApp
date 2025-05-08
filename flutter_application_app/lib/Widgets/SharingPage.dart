import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteCard.dart';
import 'package:flutter_application_app/Widgets/NoteEditPage.dart';
import 'package:flutter_application_app/Widgets/CreateNotePage.dart';

class SharingPage extends StatefulWidget {
  const SharingPage({super.key});

  @override
  State<SharingPage> createState() => _SharingPageState();
}

class _SharingPageState extends State<SharingPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AppProvider>().fetchNotes(sharing: true));
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
                    print(note['pex']);
                    if (note['pex'] == "2") {
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
                        await context.read<AppProvider>().fetchNotes(sharing: true);
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You don't have permission to edit this note"),
                          ),
                        );
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
                    print(note['pex']);
                    if (note['pex'] == "2") {
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
                        await context.read<AppProvider>().fetchNotes(sharing: true);
                      }
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You don't have permission to edit this note"),
                          ),
                        );
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
            context.read<AppProvider>().fetchNotes(sharing: true);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

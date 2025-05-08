import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteCard.dart';
import 'package:flutter_application_app/Widgets/NoteEditPage.dart';

class NoteblockNoteList extends StatefulWidget {
  final int notepadId;

  const NoteblockNoteList({super.key, required this.notepadId});

  @override
  State<NoteblockNoteList> createState() => _NoteblockNoteListState();
}

class _NoteblockNoteListState extends State<NoteblockNoteList> {
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    await context.read<AppProvider>().fetchNotes(idNotepad: widget.notepadId);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final notes = appProvider.notes;

    if (appProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appProvider.hasError) {
      return const Center(child: Text("Errore nel caricamento delle note."));
    }

    if (notes.isEmpty) {
      return const Center(child: Text("Nessuna nota in questo blocco."));
    }

    return RefreshIndicator(
      onRefresh: _loadNotes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCard(
            id: (note['id'] ?? '0').toString(),
            title: note['title'] ?? '',
            body: note['body'] ?? '',
            onTap: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteEditPage(
                    noteId: int.parse(note['id'] ?? '0'),
                    title: note['title'] ?? '',
                    body: note['body'] ?? '',
                  ),
                ),
              );

              if (updated == true && context.mounted) {
                await context.read<AppProvider>().fetchNotes(idNotepad: widget.notepadId);
              }
            },
          );
        },
      ),
    );
  }
}

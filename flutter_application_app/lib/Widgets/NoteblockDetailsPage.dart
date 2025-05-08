import 'package:flutter/material.dart';
import 'package:flutter_application_app/Widgets/NoteblockNoteList.dart';

class NoteblockDetailsPage extends StatelessWidget {
  final int noteblockId;
  final String title;

  const NoteblockDetailsPage({
    super.key,
    required this.noteblockId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blocco: $title")),
      body: NoteblockNoteList(notepadId: noteblockId),
    );
  }
}

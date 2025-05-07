import 'package:flutter/material.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:provider/provider.dart';

class NoteEditPage extends StatefulWidget {
  final int noteId;
  final String title;
  final String body;

  const NoteEditPage({
    super.key,
    required this.noteId,
    required this.title,
    required this.body,
  });

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _bodyController = TextEditingController(text: widget.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final appProvider = context.read<AppProvider>();
    final successTitle = await appProvider.editNoteTitle(
      widget.noteId,
      _titleController.text,
    );
    final successBody = await appProvider.editNoteBody(
      widget.noteId,
      _bodyController.text,
    );
    print("Notes upated: ${_titleController.text}, ${_bodyController.text}");

    if (successTitle && successBody) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during update")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modify Notes"),
        actions: [
          FilledButton(
              onPressed: _saveNote,
              child: const Text("Save"),
            ),
          Padding(padding: const EdgeInsets.only(right: 16)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Insert the title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Content",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: _bodyController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Insert the content of the note",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

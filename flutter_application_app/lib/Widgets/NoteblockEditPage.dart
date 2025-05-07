import 'package:flutter/material.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:provider/provider.dart';

class NoteblockEditPage extends StatefulWidget {
  final int noteblockId;
  final String title;
  final String body;

  const NoteblockEditPage({
    super.key,
    required this.noteblockId,
    required this.title,
    required this.body,
  });

  @override
  State<NoteblockEditPage> createState() => _NoteblockEditPage();
}

class _NoteblockEditPage extends State<NoteblockEditPage> {
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

  Future<void> _saveNoteblock() async {
    final appProvider = context.read<AppProvider>();
    final successTitle = await appProvider.editNotepadTitle(
      widget.noteblockId,
      _titleController.text,
    );
    final successBody = await appProvider.editNotepadBody(
      widget.noteblockId,
      _bodyController.text,
    );
    print("Notepad upated: ${_titleController.text}, ${_bodyController.text}");

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
        title: const Text("Modify Notepad"),
        actions: [
          FilledButton(
              onPressed: null,
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
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: _bodyController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Insert the description of the notepad",
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

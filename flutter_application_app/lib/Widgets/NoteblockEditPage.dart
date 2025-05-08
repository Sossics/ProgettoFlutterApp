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

  Future<void> _deleteNoteblock() async {
    final appProvider = context.read<AppProvider>();
    final success = await appProvider.deleteNotepad(widget.noteblockId);
    
    print("Notepad elimination: ${_titleController.text}, ${_bodyController.text}");

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during deletion")),
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
              onPressed: _deleteNoteblock,
              child: const Text("Delete Notepad"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 221, 13, 78)),
              ),
            ),
          Padding(padding: const EdgeInsets.only(right: 8)),
          FilledButton(
              onPressed: _saveNoteblock,
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

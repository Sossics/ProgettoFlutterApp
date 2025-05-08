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

    if (successTitle && successBody) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during update")),
      );
    }
  }

  Future<void> _deleteNote() async {
    final appProvider = context.read<AppProvider>();
    final success = await appProvider.deleteNote(widget.noteId);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during deletion")),
      );
    }
  }

  Future<void> _shareNote() async {
    final emailController = TextEditingController();
    bool isEditPermission = false;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Share Note"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Enter recipient's email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Permission:"),
                      Switch(
                        value: isEditPermission,
                        onChanged: (value) {
                          setState(() {
                            isEditPermission = value;
                          });
                        },
                      ),
                      Text(isEditPermission ? "Edit" : "View"),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop({
                      'email': emailController.text,
                      'permission': isEditPermission ? 2 : 1,
                    });
                  },
                  child: const Text("Share"),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null || result['email'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email cannot be empty")),
      );
      return;
    }

    final appProvider = context.read<AppProvider>();
    final success = await appProvider.shareNote(
      widget.noteId,
      result['email'],
      result['permission'],
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note shared!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during sharing")),
      );
    }
  }

  Future<void> _unshareNote() async {

    final appProvider = context.read<AppProvider>();
    final success = await appProvider.unshareNote(widget.noteId);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note unshared!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during unsharing")),
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
            onPressed: _deleteNote,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 221, 13, 78)),
            ),
            child: const Text("Delete Note"),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _saveNote,
            child: const Text("Save"),
          ),
          const SizedBox(width: 16),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _shareNote,
            tooltip: 'Share Note',
            child: const Icon(Icons.share),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _unshareNote,
            tooltip: 'Unshare Note',
            child: const Icon(Icons.block),
          ),
        ],
      ),
    );
  }
}

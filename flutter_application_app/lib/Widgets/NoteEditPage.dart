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

  final TextEditingController _shareEmailController = TextEditingController();
  String _selectedRole = '0'; // Default role (Editor)

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
    _shareEmailController.dispose();
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
    final email = _shareEmailController.text;
    final permission = int.parse(_selectedRole); // Editor = 0, Viewer = 1

    final appProvider = context.read<AppProvider>();
    final success = await appProvider.shareNote(widget.noteId, email, permission);

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Note shared with $email as ${permission == 0 ? 'Editor' : 'Viewer'}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error during sharing")),
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
            child: const Text("Delete Note"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 221, 13, 78),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.only(right: 8)),
          FilledButton(
            onPressed: _saveNote,
            child: const Text("Save"),
          ),
          Padding(padding: const EdgeInsets.only(right: 8)),
          IconButton(
            onPressed: () async {
              // Open the share modal
              await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Share Note"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _shareEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Enter email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButton<String>(
                        value: _selectedRole,
                        items: const [
                          DropdownMenuItem(
                            value: '0',
                            child: Text('Editor'),
                          ),
                          DropdownMenuItem(
                            value: '1',
                            child: Text('Viewer'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                        isExpanded: true,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: _shareNote,
                      child: const Text('Share'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.share),
          ),
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

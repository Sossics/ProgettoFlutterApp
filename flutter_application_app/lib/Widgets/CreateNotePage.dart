import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  int? selectedNotepadId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();

    Future.microtask(() => context.read<AppProvider>().fetchNotepads());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _createNote() async {
    final appProvider = context.read<AppProvider>();

    if (selectedNotepadId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a Notepad")),
      );
      return;
    }

    final success = await appProvider.createNote(
      selectedNotepadId!,
      _titleController.text,
      _bodyController.text,
    );

    if (success) {
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error creating note")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    // Verifica che i notepads siano stati caricati
    if (appProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appProvider.hasError) {
      return const Center(child: Text('Errore nel caricamento dei blocchi note.'));
    }

    final notepads = appProvider.notepads[0]['Notepad'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
        actions: [
          IconButton(
            onPressed: _createNote,
            icon: const Icon(Icons.save),
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
                hintText: "Enter title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Body",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: _bodyController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: "Enter the body of the note",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Select Notepad",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            DropdownButton<int>(
              hint: const Text("Select a Notepad"),
              value: selectedNotepadId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedNotepadId = newValue;
                  print("Selected Notepad ID: $selectedNotepadId");
                });
              },
              items: notepads.map<DropdownMenuItem<int>>((notepad) {
                // print(notepad);
                int notepadId = int.tryParse(notepad['id'].toString()) ?? 0;
                return DropdownMenuItem<int>(
                  value: notepadId,
                  child: Text(notepad['title'] ?? 'Unnamed Notepad'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

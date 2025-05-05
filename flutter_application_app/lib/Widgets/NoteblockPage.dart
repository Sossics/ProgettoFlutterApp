import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteCard.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NoteblockPage extends StatefulWidget {
  const NoteblockPage({super.key});

  @override
  State<NoteblockPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NoteblockPage> {

  final StorageService _StorageService = StorageService();
  int? _uid;


  @override
  void initState() {
    super.initState();
    _loadToken();
    Future.microtask(() => context.read<AppProvider>().fetchNotepads());
  }

  Future<void> _loadToken() async {
    String? token = await _StorageService.getToken();
    // _tokenStorageService.deleteToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        _uid = decodedToken['uid'] ?? 0;
        print("UID: $_uid");
      });
    }
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final notes = appProvider.notes;

        if (!isWide) {
          // Mobile layout
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                id: note['id'] ?? '0',
                title: note['title'] ?? 'No Title',
                body: note['body'] ?? '',
              );
            },
          );
        } else {
          // Wide screen layout
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1000) crossAxisCount = 3;

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
              );
            },
          );
        }
      },
    );
  }
}

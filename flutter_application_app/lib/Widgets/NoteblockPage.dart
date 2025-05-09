import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteblockCard.dart';
import 'package:flutter_application_app/Widgets/CreateNotepadPage.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NoteblockPage extends StatefulWidget {
  const NoteblockPage({super.key});

  @override
  State<NoteblockPage> createState() => _NoteblockPageState();
}

class _NoteblockPageState extends State<NoteblockPage> {
  final StorageService _storageService = StorageService();
  int? _uid = 0;
  String? mod;

  @override
  void initState() {
    super.initState();
    _loadToken();
    Future.microtask(() => context.read<AppProvider>().fetchNotepads());
  }

  Future<void> _loadToken() async {
    String? token = await _storageService.getToken();
    mod = await _storageService.getMod();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        _uid = decodedToken['uid'] ?? 0;
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
      return const Center(
        child: Text('Errore nel caricamento dei blocchi note.'),
      );
    }

    final notepads = appProvider.notepads;
    final isJsonMode = mod == "json";
    final notesList = isJsonMode
        ? notepads
        : (notepads.isNotEmpty && notepads[0]['Notepad'] != null)
            ? notepads[0]['Notepad']
            : [];

    return Scaffold(
      body: notesList.isEmpty
          ? const Center(child: Text('Nessun blocco note trovato.'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;

                if (!isWide) {
                  // Layout mobile
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      final note = notesList[index];
                      return NoteblockCard(
                        id: (note['id'] ?? 0).toString(),
                        title: note['title'] ?? 'No Title',
                        body: note['Description'] ?? '',
                      );
                    },
                  );
                } else {
                  // Layout desktop/tablet
                  int crossAxisCount = 2;
                  if (constraints.maxWidth > 1000 &&
                      constraints.maxWidth < 1500) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth >= 1500) {
                    crossAxisCount = 4;
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      final note = notesList[index];
                      return NoteblockCard(
                        id: (note['id'] ?? 0).toString(),
                        title: note['title'] ?? 'No Title',
                        body: note['Description'] ?? '',
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
            MaterialPageRoute(builder: (context) => const CreateNotepadPage()),
          );

          if (result == true && context.mounted) {
            context.read<AppProvider>().fetchNotepads();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Widgets/NoteblockCard.dart';
import 'package:flutter_application_app/Services/StorageService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class NoteblockPage extends StatefulWidget {
  const NoteblockPage({super.key});

  @override
  State<NoteblockPage> createState() => _NoteblockPageState();
}

class _NoteblockPageState extends State<NoteblockPage> {

  final StorageService _StorageService = StorageService();
  int? _uid;
  String? mod;


  @override
  void initState() {
    super.initState();
    _loadToken();
    Future.microtask(() => context.read<AppProvider>().fetchNotepads());
  }

  Future<void> _loadToken() async {
    String? token = await _StorageService.getToken();
    mod = await _StorageService.getMod();
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
      return const Center(child: Text('Errore nel caricamento dei blocchi note.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final notepads = appProvider.notepads;
        
        if (!isWide) {
          // Mobile layout
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: (mod == "json") ? notepads.length : notepads[0]['Notepad'].length,
            itemBuilder: (context, index) {
              final note;
              if (mod == "json") {
                note = notepads[index];
              }else{
                note = notepads[0]['Notepad'][index];
              }
              print(note);
              return NoteblockCard(
                id: (note['id'] ?? 0).toString(),
                title: note['title'] ?? 'No Title',
                body: note['body'] ?? '',
              );
            },
          );
        } else {
          // Wide screen layout
          int crossAxisCount = 2;
          if (constraints.maxWidth > 1000 && constraints.maxWidth < 1500) crossAxisCount = 3;
          if (constraints.maxWidth > 1500) crossAxisCount = 4;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: (mod == "json") ? notepads.length : notepads[0]['Notepad'].length,
            itemBuilder: (context, index) {
              final note;
              if (mod == "json") {
                note = notepads[index];
              }else{
                note = notepads[0]['Notepad'][index];
              }
              print(note);
              return NoteblockCard(
                id: (note['id'] ?? 0).toString(),
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

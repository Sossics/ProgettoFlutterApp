import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_app/Provider/AppProvider.dart';
import 'package:flutter_application_app/Style/Colors.dart';
import 'package:flutter_application_app/Widgets/NoteEditPage.dart';

class NoteCard extends StatelessWidget {
  final String id;
  final String title;
  final String body;
  final VoidCallback onTap;

  const NoteCard({
    super.key,
    required this.id,
    required this.title,
    required this.body,
    required this.onTap,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(context).pop();
              final appProvider = context.read<AppProvider>();
              int noteID = int.parse(id);
              final success = await appProvider.deleteNote(noteID);
              if (success) {
                await appProvider.fetchNotes();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error deleting note")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _goToEditPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditPage(
          noteId: int.parse(id),
          title: title,
          body: body,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: white,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,  // Spostiamo a destra
                children: [
                  ElevatedButton(
                    onPressed: () => _confirmDelete(context),
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      elevation: 0,
                    ),
                    child: const Text("Delete", style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  const int maxLines = 5;
                  final TextPainter textPainter = TextPainter(
                    text: TextSpan(
                      text: body,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    maxLines: maxLines,
                    textDirection: TextDirection.ltr,
                  )..layout(maxWidth: constraints.maxWidth);

                  final bool overflow = textPainter.didExceedMaxLines;

                  if (!overflow) {
                    return Text(
                      body,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade800),
                    );
                  }

                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                        stops: [0.7, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Text(
                      body,
                      maxLines: maxLines,
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


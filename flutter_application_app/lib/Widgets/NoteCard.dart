import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: white,
     // color: Color.fromARGB(255, 106, 36, 187),
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 8),
              Text(body,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

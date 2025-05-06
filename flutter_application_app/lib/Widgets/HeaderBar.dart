import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget {
  final String pageTitle;
  final String username;
  final VoidCallback? onBack;

  const HeaderBar({
    super.key,
    required this.pageTitle,
    required this.username,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: const Color.fromARGB(0, 252, 221, 255),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
              tooltip: 'Back',
            ),
          Expanded(
            child: Text(
              pageTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            username,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color.fromARGB(173, 148, 9, 212),
            child: Icon(Icons.person, color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
    );
  }
}

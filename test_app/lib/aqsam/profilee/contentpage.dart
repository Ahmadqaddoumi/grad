import 'package:flutter/material.dart';

class ContentPage extends StatelessWidget {
  final String title;
  final String content;

  const ContentPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF68316D),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          initialValue: content,
          maxLines: null,
          readOnly: true,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 16, height: 1.6),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }
}

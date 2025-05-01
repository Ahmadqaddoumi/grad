import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Agsam extends StatefulWidget {
  String title;
  IconData icon;
  VoidCallback onchange;
  Agsam({
    super.key,
    required this.title,
    required this.icon,
    required this.onchange,
  });

  @override
  State<Agsam> createState() => _AgsamState();
}

class _AgsamState extends State<Agsam> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // Handle tap event
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF68316D), // اللون البنفسجي
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Customvolunteer extends StatelessWidget {
  final String nametxt;
  final TextEditingController? controller;

  const Customvolunteer({super.key, required this.nametxt, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 10, top: 5, bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: nametxt,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff7433d3), width: 3),
          ),
        ),
      ),
    );
  }
}

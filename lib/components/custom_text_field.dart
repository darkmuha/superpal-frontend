import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: "PayToneOne",
        color: Colors.white,
      ),
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 4, color: Color(0xFFCCCCCC)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 4, color: Color(0xFFCCCCCC)),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
          fontFamily: "PayToneOne",
          color: Colors.white,
        ),
      ),
    );
  }
}

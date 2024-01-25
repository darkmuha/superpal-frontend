import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final double fontSize;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.fontSize = 19.0,
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
        contentPadding: const EdgeInsets.only(bottom: -20),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: fontSize,
          fontFamily: "PayToneOne",
          color: Colors.white,
        ),
      ),
    );
  }
}

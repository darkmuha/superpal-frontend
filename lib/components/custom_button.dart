import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;

  const CustomButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
        ),
        child: const Center(
          child: Text(
            "LOG IN",
            style: TextStyle(
                color: Colors.black, fontFamily: 'PayToneOne', fontSize: 20),
          ),
        ),
      ),
    );
  }
}

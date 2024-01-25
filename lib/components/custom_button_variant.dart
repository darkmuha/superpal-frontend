import 'package:flutter/material.dart';

class CustomButtonVariant extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final Color bgColor;
  final double verticalPadding;
  final double horizontalPadding;

  const CustomButtonVariant({
    super.key,
    required this.text,
    required this.onTap,
    this.fontSize = 28,
    this.fontWeight = FontWeight.w400,
    required this.fontColor,
    required this.bgColor,
    this.verticalPadding = 6,
    this.horizontalPadding = 26,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(41.0),
          color: bgColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: fontColor,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomButtonWithPicture extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String text;
  final double? fontSize;
  final CrossAxisAlignment crossAxisAlignment;

  const CustomButtonWithPicture({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.text,
    this.fontSize,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.85 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFF707070),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              width: 0.35 * 0.85 * MediaQuery.of(context).size.width,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize ?? 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

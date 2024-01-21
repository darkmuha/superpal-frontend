import 'package:flutter/material.dart';

class CustomButtonWithPictureVariant extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? text;
  final double? titleFontSize;
  final double? textFontSize;
  final CrossAxisAlignment crossAxisAlignment;
  final Color? backgroundColor;
  final int backgroundColorAlpha;
  final VoidCallback? onTap;

  const CustomButtonWithPictureVariant({
    super.key,
    required this.imageUrl,
    required this.title,
    this.text,
    this.titleFontSize,
    this.textFontSize,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.backgroundColor,
    this.backgroundColorAlpha = 160,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 0.85 * MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: (backgroundColor ?? const Color(0xFF6C7D93))
              .withAlpha(backgroundColorAlpha),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(imageUrl),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFontSize ?? 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (text != null && text!.isNotEmpty) ...[
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textFontSize ?? 12,
                  ),
                ),
              ),
              const SizedBox(height: 7),
            ],
          ],
        ),
      ),
    );
  }
}

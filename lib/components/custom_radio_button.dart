import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRadioButton extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool?> onChanged;
  final String? svgAssetPath;
  final String text;
  final double? iconSize;
  final double? fontSize;
  final int highlight;

  const CustomRadioButton({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.text,
    this.svgAssetPath,
    this.iconSize,
    this.fontSize,
    this.highlight = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!selected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 18),
        decoration: BoxDecoration(
          color: (selected && highlight == 2)
              ? Colors.black.withOpacity(0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(41.0), // Add round edges here
        ),
        child: Row(
          children: [
            if (svgAssetPath != null && svgAssetPath!.isNotEmpty)
              SvgPicture.asset(
                svgAssetPath!,
                width: iconSize ?? 21.0,
                height: iconSize ?? 21.0,
                color: selected ? const Color(0xFFFF9D00) : Colors.white,
              ),
            if (svgAssetPath != null && svgAssetPath!.isNotEmpty)
              const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 19.0,
                color: (selected && highlight == 1)
                    ? const Color(0xFFFF9D00)
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

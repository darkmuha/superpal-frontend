import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRadioButton extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool?> onChanged;
  final String? svgAssetPath;
  final String text;
  final double? iconSize;
  final double? fontSize;

  const CustomRadioButton({
    Key? key,
    required this.selected,
    required this.onChanged,
    required this.text,
    this.svgAssetPath,
    this.iconSize,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!selected);
      },
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
              color: selected ? const Color(0xFFFF9D00) : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

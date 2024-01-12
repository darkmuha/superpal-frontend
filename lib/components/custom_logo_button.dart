import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomLogoButton extends StatelessWidget {
  final String? iconPath;
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final Color? iconColor;
  final Color borderColor;
  final double iconWidth;
  final double iconHeight;
  final double width;
  final double fontSize;
  final double borderWidth;
  final Icon? icon;
  final FontWeight? fontWeight;

  const CustomLogoButton({
    Key? key,
    this.iconPath,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
    this.iconColor,
    this.iconWidth = 24,
    this.iconHeight = 24,
    this.width = 0.0, // Default value for width
    this.icon,
    this.fontSize = 19.0, // Default value for fontSize
    this.fontWeight,
    this.borderColor = Colors.transparent, // Default value for borderColor
    this.borderWidth = 0.0, // Default value for borderWidth
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: width ?? screenWidth * 0.9,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            icon!
          else if (iconPath != null)
            SvgPicture.asset(
              iconPath!,
              width: iconWidth,
              height: iconHeight,
              color: iconColor,
            ),
          const SizedBox(width: 8),
          Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ],
      ),
    );
  }
}

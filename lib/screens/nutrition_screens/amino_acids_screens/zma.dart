import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class ZMAScreen extends StatelessWidget {
  const ZMAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'ZMA',
      imageUrl: 'assets/images/zma.jpg',
      explanationText:
          'ZMA, or zinc magnesium aspartate, is a popular supplement among athletes, bodybuilders, and fitness enthusiasts. It contains a combination of three ingredients — zinc, magnesium, and vitamin B6.',
      usageText:
          'Zinc supplements are most effective if they are taken at least 1 hour before or 2 hours after meals.',
    );
  }
}

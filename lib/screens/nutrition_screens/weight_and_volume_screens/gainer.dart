import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class GainerScreen extends StatelessWidget {
  const GainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'GAINER',
      imageUrl: 'assets/images/gainer.jpg',
      explanationText:
          'A mass gainer is a supplement that provides protein, carbohydrates and possibly fats with the intention of helping to add muscle mass. It is a high-calorie protein powder aimed at increasing your daily calorie intake to promote weight gain.',
      usageText:
          'You should take mass gainer supplements after your exercise at the gym when your body craves nutrition the most.',
    );
  }
}

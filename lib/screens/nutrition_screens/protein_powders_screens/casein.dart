import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class CaseinScreen extends StatelessWidget {
  const CaseinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'CASEIN',
      imageUrl: 'assets/images/casein.jpg',
      explanationText:
          'Casein and whey protein are both derived from milk. They differ in digestion times — casein digests slowly, making it good before bedtime, while whey digests quickly and is ideal for workouts and muscle growth. ',
      usageText:
          'Drinking a casein shake just before overnight sleep increases gains in muscle mass and strength in response to resistance exercise.',
    );
  }
}

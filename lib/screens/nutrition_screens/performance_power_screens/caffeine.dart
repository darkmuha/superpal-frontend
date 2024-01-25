import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class CaffeineScreen extends StatelessWidget {
  const CaffeineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'CAFFEINE',
      imageUrl: 'assets/images/caffeine.jpg',
      explanationText:
          'Both caffeine pills and preworkouts have caffeine as the main ingredient. Caffeine is essential for exercise as it improves focus, energy, and endurance. The extra boost of energy helps you get more out of your workout, scaling you to your goals quicker. While you can get your caffeine fix from your morning cup of coffee, most people prefer taking a formula that is specifically formulated for athletes.',
      usageText:
          'The recommended dose varies by body weight, but is typically about 200–400 mg, taken 30–60 minutes before a workout.',
    );
  }
}

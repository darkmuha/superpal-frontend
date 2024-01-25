import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class TribulusScreen extends StatelessWidget {
  const TribulusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'TRIBULUS',
      imageUrl: 'assets/images/tribulus.png',
      explanationText:
          'Tribulus is a plant that produces fruit covered with spines. Rumor has it that tribulus is also known as puncture vine because its sharp spines can flatten bicycle tires. People use the fruit, leaf, and root as medicine. Tribulus has chemicals that might increase levels of some hormones. However, it doesn’t appear to increase male hormones (testosterone) in humans. ',
      usageText:
          '250 mg tribulus powdered extract three times daily taken after meals for 3 months.',
    );
  }
}

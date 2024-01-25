import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class CLAScreen extends StatelessWidget {
  const CLAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'CLA',
      imageUrl: 'assets/images/cla.jpg',
      explanationText:
          'CLA is a type of omega-6 fatty acid. While it is technically a trans fat, it’s very different from the industrial trans fats that harm your health. The main dietary sources of CLA are the meat and milk of ruminants, such as cows, goats and sheep.The total amounts of CLA in these foods varies greatly depending on what the animals ate',
      usageText:
          'Most people see the best results from CLA supplementation when they take it with food. Taking it during or right before a meal can help the body to better utilize the CLA.',
    );
  }
}

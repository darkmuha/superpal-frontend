import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class WheyScreen extends StatelessWidget {
  const WheyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'WHEY PROTEIN',
      imageUrl: 'assets/images/whey.jpg',
      explanationText:
          'Whey protein, or whey protein, is a mixture of proteins isolated from whey that occurs as a byproduct in cheese production.',
      usageText:
          'It is best when consumed right before, after or during a workout.',
    );
  }
}

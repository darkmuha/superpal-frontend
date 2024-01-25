import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class BCAAScreen extends StatelessWidget {
  const BCAAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'BCAA',
      imageUrl: 'assets/images/bcaa.png',
      explanationText:
          'Branched-chain amino acids (BCAAs) are a group of three essential amino acids: leucine, isoleucine and valine. BCAA supplements are commonly taken in order to boost muscle growth and enhance exercise performance.',
      usageText: 'BCAAs can be taken before, during, and after workouts',
    );
  }
}

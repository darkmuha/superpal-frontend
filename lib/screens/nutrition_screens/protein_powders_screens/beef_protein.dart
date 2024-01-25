import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class BeefProteinScreen extends StatelessWidget {
  const BeefProteinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'BEEF PROTEIN',
      imageUrl: 'assets/images/beef_protein.jpg',
      explanationText:
          'Branched-chain amino acids (BCAAs) are a group aBeef Protein Isolate has an amino acid profile that is easily comparable to any standard whey protein on the market. … It is naturally high in the amino acids alanine, arginine, glutamic acid.and valine. BCAA supplements are commonly taken in order to boost muscle growth and enhance exercise performance.',
      usageText:
          'It is best when consumed right before, after or during a workout.',
    );
  }
}

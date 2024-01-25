import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class VeganProteinScreen extends StatelessWidget {
  const VeganProteinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'VEGAN (PEA) PROTEIN',
      imageUrl: 'assets/images/vegan_protein.jpg',
      explanationText:
          'Pea protein powder is a popular supplement made by extracting protein from peas. Not only does it add more protein and iron to your diet, but it’s also naturally hypoallergenic and vegan.',
      usageText:
          'It is best when consumed right before, after or during a workout.',
    );
  }
}

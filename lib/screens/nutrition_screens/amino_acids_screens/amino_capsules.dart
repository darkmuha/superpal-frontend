import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class AminoCapsulesScreen extends StatelessWidget {
  const AminoCapsulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'AMINO CAPSULES',
      imageUrl: 'assets/images/amino_capsules.jpg',
      explanationText:
          'Amino acids are sometimes referred to as the building blocks of life or the building blocks of protein. They are organic compounds that the human body uses to help form protein. All amino acids contain oxygen, carbon, hydrogen, and nitrogen.',
      usageText:
          'Your muscle growth may be increased if you consume essential amino acids shortly before or after exercise.',
    );
  }
}

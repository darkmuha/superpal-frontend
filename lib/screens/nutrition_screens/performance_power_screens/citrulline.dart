import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class CitrullineScreen extends StatelessWidget {
  const CitrullineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'CITRULLINE',
      imageUrl: 'assets/images/citrulline.jpg',
      explanationText:
          'L-citrulline is a substance called a non-essential amino acid. Your kidneys change L-citrulline into another amino acid called L-arginine and a chemical called nitric oxide. These compounds are important to your heart and blood vessel health. They may also boost your immune system.',
      usageText:
          'To see the best results, take a supplement that contains Citrulline about 30 minutes before your workout.',
    );
  }
}

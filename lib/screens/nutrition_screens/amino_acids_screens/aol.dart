import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class AOLScreen extends StatelessWidget {
  const AOLScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'AOL',
      imageUrl: 'assets/images/aol.jpg',
      explanationText:
          'OstroVit AOL is a powder dietary supplement that supplements the diet with three synergistically acting amino acids: L-arginine alpha-ketoglutarate (AAKG), L-ornithine and L-lysine.',
      usageText: 'One portion (4 Pills) before sleep.',
    );
  }
}

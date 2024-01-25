import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class GlutamineScreen extends StatelessWidget {
  const GlutamineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'GLUTAMINE',
      imageUrl: 'assets/images/glutamine.png',
      explanationText:
          'Glutamine is the most abundant amino acid in our bodies. It works to support many healthy functions, including: Making proteins for muscle tissue. Fueling cells that protect our intestines. Supporting immune system cells.',
      usageText:
          'For glutamine, it’s important that you take the supplement post-workout, like half an hour into the training session, to increase its bioavailability.',
    );
  }
}

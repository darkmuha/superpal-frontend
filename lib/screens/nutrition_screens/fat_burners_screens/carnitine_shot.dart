import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class CarnitineShotScreen extends StatelessWidget {
  const CarnitineShotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'L - CARNITINE SHOT',
      imageUrl: 'assets/images/carnitine_shots.jpg',
      explanationText:
          'L-carnitine is a naturally occurring amino acid derivative that’s often taken as a supplement. It is used for weight loss and may have an impact on brain function. L - carnitine is a nutrient and dietary supplement. It plays a crucial role in the production of energy by transporting fatty acids into your cells’ mitochondria.',
      usageText:
          'It is recommended that you take between 2-4g of L-carnitine per day, divided into two or three evenly split dosages.',
    );
  }
}

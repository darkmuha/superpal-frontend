import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class PreWorkoutScreen extends StatelessWidget {
  const PreWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'PRE WORKOUT',
      imageUrl: 'assets/images/pre_workout.jpg',
      explanationText:
          'Pre-workout supplements, which are powdered and mixed with water, are advertised to improve athletic performance and energy prior to exercise. However, there’s no set list of ingredients.',
      usageText:
          'They’re typically a powdered substance that you mix in water and drink before exercise.',
    );
  }
}

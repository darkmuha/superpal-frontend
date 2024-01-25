import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class CreatineScreen extends StatelessWidget {
  const CreatineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'CREATINE',
      imageUrl: 'assets/images/creatine.jpg',
      explanationText:
          'Creatine is a substance that is found naturally in muscle cells. It helps your muscles produce energy during heavy lifting or high-intensity exercise. Taking creatine as a supplement is very popular among athletes and bodybuilders in order to gain muscle, enhance strength and improve exercise performance',
      usageText:
          'On days you exercise, there are three main options regarding when to take creatine. You can take it shortly before you exercise, shortly after you exercise or at some time that isn’t close to when you exercise.',
    );
  }
}

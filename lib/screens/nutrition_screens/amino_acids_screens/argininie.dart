import 'package:flutter/material.dart';
import '../../../components/reusable_info.dart';

class ArgininieScreen extends StatelessWidget {
  const ArgininieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReusableInfoScreen(
      titleText: 'ARGININIE',
      imageUrl: 'assets/images/argininie.jpg',
      explanationText:
          'By reducing the fat stores underneath the skin and promoting muscle growth, Arginine can improve muscle strength. Increased strength through building muscle mass is not the only benefit. By serving as a precursor for the nitric oxide, Arginine promotes endurance and muscle conditioning.',
      usageText:
          'L-arginine should be taken at least 3 times a day: in the morning and one each before and after working out. The recommended dose is between 2 to 6 grams.',
    );
  }
}

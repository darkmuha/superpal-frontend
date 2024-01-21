import 'package:flutter/material.dart';
import '../components/common_layout.dart';
import '../components/custom_button_with_picture_variant.dart';

class SuperPalScreen extends StatelessWidget {
  const SuperPalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/superpals_background_cropped.png',
      selectedIndex: 2,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Text(
                'Once you plan a workout on SuperPal Finder they become your SuperPals. You can reach them again on SuperPal Finder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            const CustomButtonWithPictureVariant(
              imageUrl: 'assets/images/my_superpals_cropped.jpg',
              title: 'MY SUPERPALS',
              text: 'See your SuperPals, Plan a Workout',
              titleFontSize: 28,
              textFontSize: 14,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            const SizedBox(height: 34),
            const CustomButtonWithPictureVariant(
              imageUrl: 'assets/images/fist_bump_cropped.jpg',
              title: 'SUPERPAL FINDER',
              text: 'Plan a Workout With New People',
              titleFontSize: 28,
              textFontSize: 14,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}

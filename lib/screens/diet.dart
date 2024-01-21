import 'package:flutter/material.dart';
import 'package:superpal/components/custom_card.dart';
import '../components/common_layout.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double targetWidth = screenWidth * 0.9;

    return CommonLayout(
      imageUrl: 'assets/images/nutrition_background_cropped.png',
      selectedIndex: 3,
      body: buildBody(targetWidth),
    );
  }

  Widget buildBody(double targetWidth) {
    return SizedBox(
      width: targetWidth,
      child: const Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'NUTRITION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(height: 33),
            Text(
              'DIET',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 126),
            CustomCard(
              imagePath: 'assets/images/vegan_cropped.jpg',
              textContent: 'VEGAN',
              routeName: '/vegan',
            ),
            SizedBox(height: 43),
            CustomCard(
              imagePath: 'assets/images/non-vegan_cropped.jpg',
              textContent: 'NON-VEGAN',
              routeName: '/non_vegan',
            ),
          ],
        ),
      ),
    );
  }
}

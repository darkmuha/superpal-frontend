import 'package:flutter/material.dart';
import 'package:superpal/components/custom_card.dart';
import '../../components/common_layout.dart';

class SupplementsScreen extends StatelessWidget {
  const SupplementsScreen({super.key});

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
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'NUTRITION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'SUPPLEMENTS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 60),
            ...buildCustomCards([
              {
                'imagePath': 'assets/images/performance_power_cropped.jpg',
                'textContent': 'PERFORMANCE - POWER',
                'routeName': '/performance_power'
              },
              {
                'imagePath': 'assets/images/fat_burners_cropped.jpg',
                'textContent': 'FAT BURNERS',
                'routeName': '/fat_burners'
              },
              {
                'imagePath': 'assets/images/weight_and_volume_cropped.jpg',
                'textContent': 'WEIGHT AND VOLUME',
                'routeName': '/weight_and_volume'
              },
              {
                'imagePath': 'assets/images/amino_acids_cropped.jpg',
                'textContent': 'AMINO ACIDS',
                'routeName': '/amino_acids.dart'
              },
              {
                'imagePath': 'assets/images/protein_powders_cropped.png',
                'textContent': 'PROTEIN POWDERS',
                'routeName': '/protein_powders'
              },
            ]),
          ],
        ),
      ),
    );
  }

  List<Widget> buildCustomCards(List<Map<String, String>> cardDataList) {
    return cardDataList.map((cardData) {
      return Column(
        children: [
          CustomCard(
            imagePath: cardData['imagePath']!,
            textContent: cardData['textContent']!,
            routeName: cardData['routeName']!,
          ),
          const SizedBox(height: 14),
        ],
      );
    }).toList();
  }
}

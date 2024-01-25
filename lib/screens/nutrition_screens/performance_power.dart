import 'package:flutter/material.dart';
import 'package:superpal/components/custom_card.dart';
import '../../components/common_layout.dart';

class PerformancePowerScreen extends StatelessWidget {
  const PerformancePowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double targetWidth = screenWidth * 0.9;

    return CommonLayout(
      imageUrl: 'assets/images/nutrition_background_cropped.png',
      selectedIndex: 3,
      body: buildBody(targetWidth, context),
    );
  }

  Widget buildBody(double targetWidth, BuildContext context) {
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
              'PERFORMANCE - POWER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 29),
            const Text(
              'Performance supplements can contain many ingredients like vitamins and minerals, protein, amino acids, and herbs in different amounts and in many combinations. These products are sold in various forms, such as capsules, tablets, liquids, and powders.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.42,
              child: buildCustomCards([
                {
                  'imagePath': 'assets/images/pre_workout_cropped.jpg',
                  'textContent': 'PRE - WORKOUT',
                  'routeName': '/pre_workout',
                },
                {
                  'imagePath': 'assets/images/citrulline_cropped.jpg',
                  'textContent': 'CITRULLINE',
                  'routeName': '/citrulline',
                },
                {
                  'imagePath': 'assets/images/creatine_cropped.jpg',
                  'textContent': 'CREATINE',
                  'routeName': '/creatine',
                },
                {
                  'imagePath': 'assets/images/tribulus_cropped.png',
                  'textContent': 'TRIBULUS',
                  'routeName': '/tribulus',
                },
                {
                  'imagePath': 'assets/images/caffeine_cropped.jpg',
                  'textContent': 'CAFFEINE',
                  'routeName': '/caffeine',
                },
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCustomCard(Map<String, String> cardData) {
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
  }

  Widget buildCustomCards(List<Map<String, String>> cardDataList) {
    return ListView.builder(
      itemCount: cardDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCustomCard(cardDataList[index]);
      },
    );
  }
}

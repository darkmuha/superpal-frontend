import 'package:flutter/material.dart';
import 'package:superpal/components/custom_card.dart';
import '../../components/common_layout.dart';

class FatBurnersScreen extends StatelessWidget {
  const FatBurnersScreen({super.key});

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
              'FAT BURNERS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 29),
            const Text(
              'Fat burners are any dietary supplements or related substances that claim to burn excess fat from your body. Some of these fat burners are naturally occurring.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: buildCustomCards([
                {
                  'imagePath': 'assets/images/cla_cropped.jpg',
                  'textContent': 'CLA',
                  'routeName': '/cla',
                },
                {
                  'imagePath': 'assets/images/carnitine_shots_cropped.jpg',
                  'textContent': 'L - CARNITINE SHOT',
                  'routeName': '/carnitine_shot',
                },
                {
                  'imagePath': 'assets/images/carnitine_capsules_cropped.jpg',
                  'textContent': 'L- CARNITINE CAPSULES',
                  'routeName': '/carnitine_capsules',
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
        const SizedBox(height: 30),
      ],
    );
  }

  Widget buildCustomCards(List<Map<String, String>> cardDataList) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cardDataList.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCustomCard(cardDataList[index]);
      },
    );
  }
}

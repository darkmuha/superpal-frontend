import 'package:flutter/material.dart';
import 'package:superpal/components/custom_card.dart';
import '../../components/common_layout.dart';

class WeightAndVolumeScreen extends StatelessWidget {
  const WeightAndVolumeScreen({super.key});

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
              'WEIGHT AND VOLUME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 29),
            const Text(
              'Though weight loss is a very common goal, many people actually want to gain weight. Some common reasons include improving daily functioning, looking more muscular and enhancing athleticism.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: buildCustomCards([
                {
                  'imagePath': 'assets/images/gainer_cropped.jpg',
                  'textContent': 'GAINER',
                  'routeName': '/gainer',
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

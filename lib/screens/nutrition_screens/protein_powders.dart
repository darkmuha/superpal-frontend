import 'package:flutter/material.dart';
import 'package:superpal/components/custom_card.dart';
import '../../components/common_layout.dart';

class ProteinPowdersScreen extends StatelessWidget {
  const ProteinPowdersScreen({super.key});

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
              'PROTEIN POWDERS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 29),
            const Text(
              'Branched-chain amino acids (BCAAs) are a group of three essential amino acids: leucine, isoleucine and valine. BCAA supplements are commonly taken in order to boost muscle growth and enhance exercise performance.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w100,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 26),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.41,
              child: buildCustomCards([
                {
                  'imagePath': 'assets/images/whey_cropped.jpg',
                  'textContent': 'WHEY PROTEIN',
                  'routeName': '/whey',
                },
                {
                  'imagePath': 'assets/images/whey_isolate_cropped.jpg',
                  'textContent': 'WHEY ISOLATE PROTEIN',
                  'routeName': '/whey_isolate',
                },
                {
                  'imagePath': 'assets/images/casein_cropped.jpg',
                  'textContent': 'CASEIN',
                  'routeName': '/casein',
                },
                {
                  'imagePath': 'assets/images/beef_protein_cropped.jpg',
                  'textContent': 'BEEF PROTEIN',
                  'routeName': '/beef_protein',
                },
                {
                  'imagePath': 'assets/images/vegan_protein_cropped.jpg',
                  'textContent': 'VEGAN (PEA) PROTEIN',
                  'routeName': '/vegan_protein',
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

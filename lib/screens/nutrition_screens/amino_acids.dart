import 'package:flutter/material.dart';
import 'package:superpal/components/custom_card.dart';
import '../../components/common_layout.dart';

class AminoAcidsScreen extends StatelessWidget {
  const AminoAcidsScreen({super.key});

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
              'AMINO ACIDS',
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
                  'imagePath': 'assets/images/bcaa_cropped.png',
                  'textContent': 'BCAA',
                  'routeName': '/bcaa',
                },
                {
                  'imagePath': 'assets/images/glutamine_cropped.png',
                  'textContent': 'GLUTAMINE',
                  'routeName': '/glutamine',
                },
                {
                  'imagePath': 'assets/images/argininie_cropped.jpg',
                  'textContent': 'ARGININIE',
                  'routeName': '/argininie',
                },
                {
                  'imagePath': 'assets/images/amino_capsules_cropped.jpg',
                  'textContent': 'AMINO CAPSULES',
                  'routeName': '/amino_capsules',
                },
                {
                  'imagePath': 'assets/images/aol_cropped.jpg',
                  'textContent': 'AOL',
                  'routeName': '/aol',
                },
                {
                  'imagePath': 'assets/images/zma_cropped.jpg',
                  'textContent': 'ZMA',
                  'routeName': '/zma',
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

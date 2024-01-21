import 'package:flutter/material.dart';
import '../../components/common_layout.dart';
import '../../components/custom_button_with_picture_variant.dart';

class NonVeganScreen extends StatelessWidget {
  const NonVeganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/nutrition_background_cropped.png',
      selectedIndex: 3,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
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
          const SizedBox(height: 70),
          const Text(
            'NON - VEGAN',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 26),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.53,
            child: buildCustomButtonsList(),
          ),
        ],
      ),
    );
  }

  Widget buildCustomButtonsList() {
    return ListView.builder(
      itemCount: NonVeganScreenData.customButtonsData.length,
      itemBuilder: (context, index) {
        var data = NonVeganScreenData.customButtonsData[index];
        return Column(
          children: [
            CustomButtonWithPictureVariant(
              imageUrl: data['imageUrl'],
              title: data['title'],
              text: data['text'],
              titleFontSize: data['titleFontSize'].toDouble(),
              textFontSize: data['textFontSize'].toDouble(),
              crossAxisAlignment: data['crossAxisAlignment'],
              backgroundColor: const Color(0xFF5A544F),
            ),
            const SizedBox(height: 34),
          ],
        );
      },
    );
  }
}

class NonVeganScreenData {
  static const List<Map<String, dynamic>> customButtonsData = [
    {
      'imageUrl': 'assets/images/eggs_cropped.jpg',
      'title': 'EGGS',
      'text':
          'Eggs contain high-quality protein, healthy fats and other important nutrients like B vitamins and choline. Proteins are made up of amino acids, and eggs contain large amounts of the amino acid leucine, which is particularly important for muscle gain',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/salmon_cropped.jpg',
      'title': 'SALMON',
      'text':
          'Salmon is a great choice for muscle building and overall health. Each 3-ounce (85-gram) serving of salmon contains about 17 grams of protein, almost 2 grams of omega-3 fatty acids and several important B vitamins',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/chicken_breast_cropped.jpg',
      'title': 'CHICKEN BREAST',
      'text':
          'There’s a good reason why chicken breasts are considered a staple for gaining muscle. They are packed with protein, with each 3-ounce (85-gram) serving containing about 26 grams of high-quality protein',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/greek_yogurt_cropped.jpg',
      'title': 'GREEK YOGURT',
      'text':
          'Dairy not only contains high-quality protein, but also a mixture of fast-digesting whey protein and slow-digesting casein protein. Some research has shown that people experience increases in lean mass when they consume a combination of fast- and slow-digesting dairy proteins',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/tuna_cropped.jpg',
      'title': 'TUNA',
      'text':
          'In addition to 20 grams of protein per 3-ounce (85-gram) serving, tuna contains high amounts of vitamin A and several B vitamins, including B12, niacin and B6. These nutrients are important for optimal health, energy and exercise performance',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/lean_beef_cropped.jpg',
      'title': 'LEAN BEEF',
      'text':
          'Beef is packed with high-quality protein, B vitamins, minerals and creatine. Some research has even shown that consuming lean red meat can increase the amount of lean mass gained with weight training',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
  ];
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/common_layout.dart';
import '../components/custom_button_with_picture_variant.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

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
          const SizedBox(height: 67),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: const Text(
              'Basic supplements and foods are listed in the categories which are advisory by the nutritionists. You can do your own research and consult with a dietician for detailed information if you have any kind of allergies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 27),
          CustomButtonWithPictureVariant(
            imageUrl: 'assets/images/nutrition_nutrition_cropped.jpg',
            title: 'NUTRITION',
            text: 'You can’t escape from the reality of vitamins ',
            titleFontSize: 28,
            textFontSize: 14,
            crossAxisAlignment: CrossAxisAlignment.center,
            backgroundColor: const Color(0xFF5A544F),
            backgroundColorAlpha: 200,
            onTap: () {
              Get.toNamed('/supplements');
            },
          ),
          const SizedBox(height: 34),
          CustomButtonWithPictureVariant(
            imageUrl: 'assets/images/nutrition_diet_cropped.jpg',
            title: 'DIET',
            text: 'Heroes always know what to eat',
            titleFontSize: 28,
            textFontSize: 14,
            crossAxisAlignment: CrossAxisAlignment.center,
            backgroundColor: const Color(0xFF5A544F),
            backgroundColorAlpha: 200,
            onTap: () {
              Get.toNamed('/diet');
            },
          ),
        ],
      ),
    );
  }
}

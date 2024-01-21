import 'package:flutter/material.dart';
import '../../components/common_layout.dart';
import '../../components/custom_button_with_picture_variant.dart';

class VeganScreen extends StatelessWidget {
  const VeganScreen({super.key});

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
            'VEGAN',
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
      itemCount: VeganScreenData.customButtonsData.length,
      itemBuilder: (context, index) {
        var data = VeganScreenData.customButtonsData[index];
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

class VeganScreenData {
  static const List<Map<String, dynamic>> customButtonsData = [
    {
      'imageUrl': 'assets/images/soybeans_cropped.jpg',
      'title': 'SOYBEANS',
      'text':
          'Half a cup (86 grams) of cooked soybeans contains 14 grams of protein, healthy unsaturated fats and several vitamins and minerals',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/beans_cropped.jpg',
      'title': 'BEANS',
      'text':
          'Many different varieties of beans can be part of a diet for lean muscle gain. Popular varieties, such as black, pinto and kidney beans, contain around 15 grams of protein per cup (about 172 grams) of cooked beans',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/edamame_cropped.jpg',
      'title': 'EDAMAME',
      'text':
          'Edamame is the term for immature soybeans. These developing beans are found in pods and served in a variety of dishes, particularly those of Asian origin. One cup (155 grams) of frozen edamame provides around 17 grams of protein and 8 grams of fiber. It also contains large amounts of folate, vitamin K and manganese',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/quinoa_cropped.jpg',
      'title': 'QUINOA',
      'text':
          'While protein-rich foods are a priority for building lean muscle, it’s also important to have the fuel to get active. Foods with carbohydrates can help provide this energy',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/buckwheat_cropped.jpg',
      'title': 'BUCKWHEAT',
      'text':
          'Buckwheat is a seed that can be ground into flour and used in place of traditional flours. Half a cup (60 grams) of buckwheat flour contains around 8 grams of protein, along with plenty of fiber and other carbs.',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/almonds_cropped.jpg',
      'title': 'ALMONDS',
      'text':
          'Half a cup (about 172 grams) of blanched almonds provides 16 grams of protein and large amounts of vitamin E, magnesium and phosphorus. Among other roles, phosphorus helps your body use carbohydrates and fats for energy at rest and during exercise.',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
    {
      'imageUrl': 'assets/images/brown_rice_cropped.jpg',
      'title': 'BROWN RICE',
      'text':
          'Although cooked brown rice provides only 5 grams of protein per cup (195 grams), it has the carbohydrates you need to fuel your physical activity. Consider eating healthy carb sources like brown rice or quinoa in the hours leading up to exercise.',
      'titleFontSize': 28,
      'textFontSize': 14,
      'crossAxisAlignment': CrossAxisAlignment.center,
    },
  ];
}

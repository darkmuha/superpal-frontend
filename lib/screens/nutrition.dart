import 'package:flutter/material.dart';
import '../components/common_layout.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonLayout(
      selectedIndex: 3,
      body: Center(
        child: Text(
          'Nutrition Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

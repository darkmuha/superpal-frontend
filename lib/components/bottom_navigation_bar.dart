import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/home.dart';
import '../screens/nutrition.dart';
import '../screens/ranking.dart';
import '../screens/superpal.dart';
import '../screens/workout.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    HomeScreen(),
    WorkoutScreen(),
    SuperPalScreen(),
    NutritionScreen(),
    RankingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex], // Show the selected page
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 36, left: 21, right: 21),
        padding:
        const EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavItem("assets/icons/home.svg", 0),
            buildNavItem("assets/icons/workout.svg", 1),
            buildNavItem("assets/icons/superpal.svg", 2),
            buildNavItem("assets/icons/nutrition.svg", 3),
            buildNavItem("assets/icons/ranking.svg", 4),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(String iconPath, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: SvgPicture.asset(
        iconPath,
        height: 27,
        color: isSelected ? Colors.red : Colors.black,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}

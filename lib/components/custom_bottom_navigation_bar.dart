import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigationBar({super.key, 
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 36, left: 21, right: 21),
      padding: const EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildNavItem("assets/icons/home.svg", 0, '/home'),
          buildNavItem("assets/icons/workout.svg", 1, '/workout'),
          buildNavItem("assets/icons/superpal.svg", 2, '/superpal'),
          buildNavItem("assets/icons/nutrition.svg", 3, '/nutrition'),
          buildNavItem("assets/icons/ranking.svg", 4, '/ranking'),
        ],
      ),
    );
  }

  Widget buildNavItem(String iconPath, int index, String routeName) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Get.toNamed(routeName);
        }
      },
      child: SvgPicture.asset(
        iconPath,
        height: routeName == '/ranking' ? 30 : 27,
        color: isSelected ? Colors.red : Colors.black,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}

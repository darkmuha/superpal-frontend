import 'package:flutter/material.dart';
import '../components/common_layout.dart';
import '../components/custom_button_with_picture.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/dumbbell.png',
      selectedIndex: 1,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'Time to Workout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 39,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const Text(
              'Exclusive programs prepared for your best results',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          const CustomButtonWithPicture(
            imageUrl: 'assets/images/dumbbell_centered_beginner_cropped.jpg',
            title: 'BEGINNER',
            text: 'Review the program',
            fontSize: 24,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 34),
          const CustomButtonWithPicture(
            imageUrl:
                'assets/images/dumbbell_centered_intermediate_cropped.jpg',
            title: 'INTERMEDIATE',
            text: 'Review the program',
            fontSize: 24,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          const SizedBox(height: 34),
          const CustomButtonWithPicture(
            imageUrl: 'assets/images/dumbbell_centered_pro_cropped.jpg',
            title: 'PROFESSIONAL',
            text: 'Review the program',
            fontSize: 24,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ],
      ),
    );
  }
}

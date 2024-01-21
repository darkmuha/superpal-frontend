import 'package:flutter/material.dart';
import '../components/common_layout.dart';
import '../components/custom_button_with_picture.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CommonLayout(
      imageUrl: 'assets/images/dumbbell.png',
      selectedIndex: 0,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Welcome Hero',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 39,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 50),
            CustomButtonWithPicture(
              imageUrl: 'assets/images/workouts_homebutton2.jpg',
              title: 'WORKOUTS',
              text: 'See your workout program and start working out',
            ),
            SizedBox(height: 34),
            CustomButtonWithPicture(
              imageUrl: 'assets/images/workouts_homebutton2.jpg',
              title: 'SUPERPALS',
              text: 'Find your SuperPal and hit the gym together!',
            ),
            SizedBox(height: 34),
            CustomButtonWithPicture(
              imageUrl: 'assets/images/workouts_homebutton2.jpg',
              title: 'NUTRITION',
              text: 'You can’t escape from the reality of vitamins',
            ),
            SizedBox(height: 34),
            CustomButtonWithPicture(
              imageUrl: 'assets/images/workouts_homebutton2.jpg',
              title: 'HERO',
              text:
                  'See the heroes of the day, month or years. Maybe you are there',
            ),
          ],
        ),
      ),
    );
  }
}

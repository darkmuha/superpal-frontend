import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/account.dart';
import 'screens/home.dart';
import 'screens/nutrition.dart';
import 'screens/ranking.dart';
import 'screens/superpal.dart';
import 'screens/workout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/account',
          page: () => const AccountScreen(),
          transition: Transition.cupertino,
        ),
        GetPage(
          name: '/workout',
          page: () => const WorkoutScreen(),
          transition: Transition.zoom,
        ),
        GetPage(
          name: '/superpal',
          page: () => const SuperPalScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/nutrition',
          page: () => const NutritionScreen(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: '/ranking',
          page: () => const RankingScreen(),
          transition: Transition.downToUp,
        ),
      ],
    );
  }
}

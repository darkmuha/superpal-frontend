import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superpal/screens/login.dart';
import 'screens/account.dart';
import 'screens/home.dart';
import 'screens/nutrition.dart';
import 'screens/ranking.dart';
import 'screens/superpal.dart';
import 'screens/workout.dart';
import 'screens/welcome.dart';

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
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const WelcomeScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          transition: Transition.fadeIn,
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

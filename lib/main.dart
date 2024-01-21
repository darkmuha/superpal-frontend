import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:superpal/screens/ranking_explained.dart';
import 'helpers/api_requests.dart';
import 'helpers/api_service.dart';

import 'screens/login.dart';
import 'screens/register.dart';
import 'helpers/constants.dart';
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
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  late final ApiRequests apiRequests;

  @override
  void initState() {
    super.initState();
    apiRequests = ApiRequests(apiService, storage);
    // checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    final hasToken = await hasJwtToken();
    if (hasToken) {
      final isTokenValid = await verifyToken();
      if (isTokenValid) {
        await getDataIfVerified();
      } else {
        Get.offAllNamed('/');
      }
    } else {
      Get.offAllNamed('/');
    }
  }

  Future<bool> hasJwtToken() async {
    final accessToken = await storage.read(key: 'access');
    final refreshToken = await storage.read(key: 'refresh');
    return accessToken != null && refreshToken != null;
  }

  Future<bool> verifyToken() async {
    try {
      final response = await apiService.dio.post(
        '${AppConstants.apiUrl}/authentication/token/verify/',
        data: {'token': await storage.read(key: 'refresh')},
      );

      return response.statusCode == 200;
    } catch (error) {
      print('Error verifying token: $error');
      return false;
    }
  }

  Future<void> getDataIfVerified() async {
    try {
      final refreshToken = await storage.read(key: 'refresh');

      final Map<String, dynamic> decodedToken =
          JwtDecoder.decode(refreshToken!);
      final customerID = decodedToken['customer_id'];

      await apiRequests.getUserDetails(customerID);

      final userDetails = await storage.read(key: 'userDetails');

      if (userDetails != null) {
        Map<String, dynamic> userDetailsJson = jsonDecode(userDetails);

        final intensity = userDetailsJson['workout_intensity'] ?? 'Beginner';
        final difficulty = userDetailsJson['workout_difficulty'] ?? 'Low';

        await apiRequests.getFilteredWorkouts(intensity, difficulty);

        await apiRequests.getUserSuperpals(customerID);
        await apiRequests.getUserSuperpalsWorkoutRequests(customerID);
        await apiRequests.getCustomersSortedByWorkoutStreak();

        Get.offAllNamed('/home');
      } else {
        print('User details not found.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/ranking',
      getPages: [
        // GetPage(
        //   name: '/',
        //   page: () => const WelcomeScreen(),
        //   transition: Transition.fadeIn,
        // ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
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
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/workout',
          page: () => const WorkoutScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/superpal',
          page: () => const SuperPalScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/nutrition',
          page: () => const NutritionScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/ranking',
          page: () => const RankingScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/rankingExplained',
          page: () => const RankingExplainedScreen(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}

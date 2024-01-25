import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'helpers/constants.dart';
import 'helpers/api_requests.dart';
import 'helpers/api_service.dart';

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
      await storage.deleteAll();
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
        await apiRequests.getUserSuperpalsWorkoutRequests(
          customerID,
        );
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
      initialRoute: '/home  ',
      getPages: AppConstants.appPages,
    );
  }
}

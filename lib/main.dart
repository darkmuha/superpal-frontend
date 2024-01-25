import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:superpal/screens/diet.dart';
import 'package:superpal/screens/diet_screens/non_vegan.dart';
import 'package:superpal/screens/diet_screens/vegan.dart';
import 'package:superpal/screens/edit_profile.dart';
import 'package:superpal/screens/superpals_screens/my_superpals.dart';
import 'package:superpal/screens/nutrition_screens/amino_acids.dart';
import 'package:superpal/screens/nutrition_screens/amino_acids_screens/amino_capsules.dart';
import 'package:superpal/screens/nutrition_screens/amino_acids_screens/aol.dart';
import 'package:superpal/screens/nutrition_screens/amino_acids_screens/argininie.dart';
import 'package:superpal/screens/nutrition_screens/amino_acids_screens/bcaa.dart';
import 'package:superpal/screens/nutrition_screens/amino_acids_screens/glutamine.dart';
import 'package:superpal/screens/nutrition_screens/amino_acids_screens/zma.dart';
import 'package:superpal/screens/nutrition_screens/fat_burners.dart';
import 'package:superpal/screens/nutrition_screens/fat_burners_screens/carnitine_capsules.dart';
import 'package:superpal/screens/nutrition_screens/fat_burners_screens/carnitine_shot.dart';
import 'package:superpal/screens/nutrition_screens/fat_burners_screens/cla.dart';
import 'package:superpal/screens/nutrition_screens/performance_power.dart';
import 'package:superpal/screens/nutrition_screens/performance_power_screens/caffeine.dart';
import 'package:superpal/screens/nutrition_screens/performance_power_screens/citrulline.dart';
import 'package:superpal/screens/nutrition_screens/performance_power_screens/creatine.dart';
import 'package:superpal/screens/nutrition_screens/performance_power_screens/pre_workout.dart';
import 'package:superpal/screens/nutrition_screens/performance_power_screens/tribulus.dart';
import 'package:superpal/screens/nutrition_screens/protein_powders.dart';
import 'package:superpal/screens/nutrition_screens/protein_powders_screens/beef_protein.dart';
import 'package:superpal/screens/nutrition_screens/protein_powders_screens/casein.dart';
import 'package:superpal/screens/nutrition_screens/protein_powders_screens/vegan_protein.dart';
import 'package:superpal/screens/nutrition_screens/protein_powders_screens/whey.dart';
import 'package:superpal/screens/nutrition_screens/protein_powders_screens/whey_isolate.dart';
import 'package:superpal/screens/nutrition_screens/supplements.dart';
import 'package:superpal/screens/nutrition_screens/weight_and_volume.dart';
import 'package:superpal/screens/nutrition_screens/weight_and_volume_screens/gainer.dart';
import 'package:superpal/screens/ranking_explained.dart';
import 'package:superpal/screens/superpals_screens/workout_planning_success.dart';
import 'package:superpal/screens/superpals_screens/workout_planning.dart';
import 'package:superpal/screens/welcome.dart';
import 'package:superpal/screens/workout_requests.dart';
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
      getPages: [
        // GetPage(
        //   name: '/',
        //   page: () => const WelcomeScreen(),
        //   transition: Transition.fadeIn,
        // ),
        GetPage(
          name: '/welcome',
          page: () => const WelcomeScreen(),
          transition: Transition.fadeIn,
        ),
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
        GetPage(
          name: '/diet',
          page: () => const DietScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/non_vegan',
          page: () => const NonVeganScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/vegan',
          page: () => const VeganScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/supplements',
          page: () => const SupplementsScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/performance_power',
          page: () => const PerformancePowerScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/pre_workout',
          page: () => const PreWorkoutScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/citrulline',
          page: () => const CitrullineScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/creatine',
          page: () => const CreatineScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/tribulus',
          page: () => const TribulusScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/caffeine',
          page: () => const CaffeineScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/fat_burners',
          page: () => const FatBurnersScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/cla',
          page: () => const CLAScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/carnitine_capsules',
          page: () => const CarnitineCapsulesScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/carnitine_shot',
          page: () => const CarnitineShotScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/weight_and_volume',
          page: () => const WeightAndVolumeScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/gainer',
          page: () => const GainerScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/amino_acids',
          page: () => const AminoAcidsScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/bcaa',
          page: () => const BCAAScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/glutamine',
          page: () => const GlutamineScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/argininie',
          page: () => const ArgininieScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/amino_capsules',
          page: () => const AminoCapsulesScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/aol',
          page: () => const AOLScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/zma',
          page: () => const ZMAScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/protein_powders',
          page: () => const ProteinPowdersScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/whey',
          page: () => const WheyScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/whey_isolate',
          page: () => const WheyIsolateScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/casein',
          page: () => const CaseinScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/beef_protein',
          page: () => const BeefProteinScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/vegan_protein',
          page: () => const VeganProteinScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/my_superpals',
          page: () => const MySuperPalsScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/workout_planning',
          page: () => WorkoutPlanningScreen(superPal: Get.arguments),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/workout_planning_success',
          page: () => WorkoutPlanningSuccessScreen(superPal: Get.arguments),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/workout_requests',
          page: () => const WorkoutRequestsScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/edit_profile',
          page: () => const EditProfileScreen(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}

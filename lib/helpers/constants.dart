import 'package:cloudinary/cloudinary.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../screens/all_screens_exports.dart';

class AppConstants {
  static const String apiUrl = 'http://192.168.0.28:8000';
  static const String googleApiKey = 'AIzaSyDcN6hGch_pwFXcSsZLCkIFrCSMDytB_N4';
  static final Cloudinary cloudinary = Cloudinary.signedConfig(
    apiKey: '894995559279246',
    apiSecret: 'CK9axl5nMdjHfVV_o6XAOpxzerU',
    cloudName: 'decb8gydy',
  );
  static final List<GetPage> appPages = [
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
  ];
}

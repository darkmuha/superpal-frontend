import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../components/common_layout.dart';
import '../../components/custom_button_variant.dart';
import '../../components/rankings_list_item.dart';

class WorkoutPlanningSuccessScreen extends StatelessWidget {
  final Map<String, dynamic> superPal;

  const WorkoutPlanningSuccessScreen({
    super.key,
    required this.superPal,
  });

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/superpals_background_cropped.png',
      selectedIndex: 2,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 5),
          const Text(
            'MY SUPERPALS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Plan a Workout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 14),
          CustomRow(
            name: superPal['first_name'],
            age: superPal['age'].toString(),
            rank: superPal['rank_named'],
            trainingDuration: superPal['workout_streak'].toString(),
            gymName: superPal['current_gym'],
            imageUrl: superPal['profile_picture'],
            detailsWidth: 0.9 * MediaQuery.of(context).size.width,
            imageSize: 56,
            spacebetweenDetailsAndGym: 10,
          ),
          const SizedBox(height: 29),
          const Text(
            'Request has been sent',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 11),
          SvgPicture.asset(
            'assets/icons/thumbs_up.svg',
            height: 77,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 62),
            child: Text(
              'You can review your current plans and workout requests in Workouts Request in Your Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          CustomButtonVariant(
            text: 'Go to Profile',
            onTap: () {
              Get.toNamed('/account');
            },
            fontColor: Colors.white,
            bgColor: const Color(0xFF222222),
            verticalPadding: 6,
            horizontalPadding: 26,
            fontSize: 28,
          ),
          const SizedBox(height: 17),
          CustomButtonVariant(
            text: 'Review Workout Requests',
            onTap: () {
              Get.toNamed('/workout_requests');
            },
            fontColor: Colors.white,
            bgColor: const Color(0xFF222222),
            verticalPadding: 9,
            horizontalPadding: 37,
            fontSize: 23,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../components/common_layout.dart';
import '../../components/rankings_list_item.dart';
import '../../helpers/api_requests.dart';
import '../../helpers/api_service.dart';

class WorkoutPlanningScreen extends StatefulWidget {
  final Map<String, dynamic> superPal;

  const WorkoutPlanningScreen({super.key, required this.superPal});

  @override
  State<WorkoutPlanningScreen> createState() => _WorkoutPlanningScreenState();
}

class _WorkoutPlanningScreenState extends State<WorkoutPlanningScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  late final ApiRequests apiRequests;

  int selectedMinutes = 0;
  int selectedHours = 0;
  String customerID = '';
  String superpalID = '';
  late DateTime workoutTime;

  final ScrollController _scrollControllerMinutes = ScrollController();
  final ScrollController _scrollControllerHours = ScrollController();

  void initState() {
    super.initState();
    apiRequests = ApiRequests(apiService, storage);
  }

  Future<void> _getCustomerId() async {
    final refreshToken = await storage.read(key: 'refresh');

    if (refreshToken != null) {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(refreshToken);
      customerID = decodedToken['customer_id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/superpals_background_cropped.png',
      selectedIndex: 2,
      body: buildBody(context),
    );
  }

  @override
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
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'Workouts can only be planned the day before',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Plan a Workout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 14),
          CustomRow(
            name: widget.superPal['first_name'],
            age: widget.superPal['age'].toString(),
            rank: widget.superPal['rank_named'],
            trainingDuration: widget.superPal['workout_streak'].toString(),
            gymName: widget.superPal['current_gym'],
            imageUrl: widget.superPal['profile_picture'],
            detailsWidth: 0.9 * MediaQuery.of(context).size.width,
            imageSize: 56,
            spacebetweenDetailsAndGym: 10,
          ),
          const SizedBox(height: 14),
          const Text(
            'Choose the time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Scroll to change time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildNumberSelector(
                  24, selectedHours, _scrollControllerHours, true),
              const SizedBox(
                width: 18,
              ),
              const Text(
                ':',
                style: TextStyle(
                  fontSize: 57,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              buildNumberSelector(
                  60, selectedMinutes, _scrollControllerMinutes, false),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await _getCustomerId();
              print('${widget.superPal.toString()} $customerID');
              superpalID = widget.superPal['id'].toString();
              DateTime now = DateTime.now();

              workoutTime = DateTime(
                now.year,
                now.month,
                now.day + 1,
                selectedHours,
                selectedMinutes,
              );
              String formattedWorkoutTime =
                  DateFormat("yyyy-MM-ddTHH:mm").format(workoutTime.toLocal());

              final isSuccessful = await apiRequests.postWorkoutRequest(
                  customerID, superpalID, formattedWorkoutTime);

              if (isSuccessful) {
                Get.toNamed('/workout_planning_success',
                    arguments: widget.superPal);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
              primary: const Color(0xFF222222),
            ),
            child: const Text('Send Workout Request',
                style: TextStyle(
                  color: Color(0xFF00CE18),
                  fontSize: 22,
                )),
          ),
        ],
      ),
    );
  }

  Widget buildNumberSelector(
      int finish, int selected, ScrollController controller, bool isHours) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      height: 108,
      width: 108,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            final currentScroll = scrollNotification.metrics.pixels;
            const itemHeight = 78.0;

            final newIndex = ((currentScroll / itemHeight)).round();

            if (isHours) {
              setState(() {
                selectedHours = newIndex % finish;
              });
            } else {
              setState(() {
                selectedMinutes = newIndex % finish;
              });
            }
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 30),
          child: ListView.custom(
            controller: controller,
            physics: const BouncingScrollPhysics(),
            itemExtent: 78.0,
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                final number = index;
                final isSelected = isHours
                    ? selectedHours == number
                    : selectedMinutes == number;

                return Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      number.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color:
                            isSelected ? const Color(0xFFFF4E4E) : Colors.black,
                        fontSize: 57,
                      ),
                    ),
                  ),
                );
              },
              childCount: finish,
            ),
          ),
        ),
      ),
    );
  }
}

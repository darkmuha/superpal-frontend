import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../components/common_layout.dart';
import '../../helpers/api_requests.dart';
import '../../helpers/api_service.dart';
import '../components/rankings_list_item.dart';

class WorkoutRequestsScreen extends StatefulWidget {
  const WorkoutRequestsScreen({super.key});

  @override
  State<WorkoutRequestsScreen> createState() => _WorkoutRequestsScreenState();
}

class _WorkoutRequestsScreenState extends State<WorkoutRequestsScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  late final ApiRequests apiRequests;
  List<dynamic>? acceptedWorkoutRequests;
  List<dynamic>? pendingWorkoutRequests;
  String customerID = '';

  @override
  void initState() {
    super.initState();
    apiRequests = ApiRequests(apiService, storage);
    _loadWorkoutRequests();
  }

  Future<void> _loadWorkoutRequests() async {
    try {
      final refreshToken = await storage.read(key: 'refresh');

      if (refreshToken != null) {
        final Map<String, dynamic> decodedToken =
            JwtDecoder.decode(refreshToken);
        customerID = decodedToken['customer_id'];

        await apiRequests.getUserSuperpalsWorkoutRequests(customerID,
            status: 'Pending');
        final pendingWorkoutRequestsEncoded =
            await storage.read(key: 'workout_requests');

        await apiRequests.getUserSuperpalsWorkoutRequests(customerID,
            status: 'Accepted');
        final acceptedWorkoutRequestsEncoded =
            await storage.read(key: 'workout_requests');
        if (pendingWorkoutRequestsEncoded != null &&
            acceptedWorkoutRequestsEncoded != null) {
          acceptedWorkoutRequests = jsonDecode(acceptedWorkoutRequestsEncoded);
          pendingWorkoutRequests = jsonDecode(pendingWorkoutRequestsEncoded);
          setState(() {});
        } else {
          print(
              'Error: pendingWorkoutRequestsEncoded or acceptedWorkoutRequestsEncoded is null');
        }
      } else {
        print('Error: refreshToken is null');
        Get.toNamed('/');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/workout_requests_background.png',
      selectedIndex: 5,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'WORKOUT REQUESTS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 11),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 46),
            child: Text(
              'You can see your current workout plans with your Pals here. Also deny and accept new requests as well',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 27),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.61,
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'CURRENT PLANS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildAcceptedCurrentList(),
                  const SizedBox(height: 50),
                  const Text(
                    'RECEIVED REQUESTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildPendingCurrentList(false),
                  const SizedBox(height: 50),
                  const Text(
                    'SENT REQUESTS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildPendingCurrentList(true),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedCurrentList() {
    return (acceptedWorkoutRequests != null && acceptedWorkoutRequests!.isEmpty)
        ? Column(
            children: acceptedWorkoutRequests!.map((workoutRequest) {
              Map<String, dynamic> otherUser;
              if (workoutRequest['sender_info']['id'] == customerID) {
                otherUser = workoutRequest['recipient_info'];
              } else {
                otherUser = workoutRequest['sender_info'];
              }
              DateTime dateTime =
                  DateTime.parse(workoutRequest['workout_time']);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomRow(
                    name: otherUser['first_name'],
                    age: otherUser['age'].toString(),
                    rank: otherUser['rank_named'],
                    trainingDuration: otherUser['workout_streak'].toString(),
                    gymName: otherUser['current_gym'],
                    imageUrl: otherUser['profile_picture'],
                    detailsWidth: 0.9 * MediaQuery.of(context).size.width,
                    imageSize: 56,
                    spacebetweenDetailsAndGym: 10,
                    workoutDay: DateFormat('EEEE').format(dateTime),
                    workoutTime: DateFormat('HH:mm').format(dateTime),
                  ),
                  const SizedBox(height: 15),
                ],
              );
            }).toList(),
          )
        : const SizedBox.shrink();
  }

  Widget _buildPendingCurrentList(bool isSent) {
    return (pendingWorkoutRequests != null &&
            pendingWorkoutRequests!.isNotEmpty)
        ? Column(
            children: pendingWorkoutRequests!.map((workoutRequest) {
              final requestId = workoutRequest['id'];
              Map<String, dynamic> otherUser;
              bool isCanceled = false;
              if (isSent && workoutRequest['sender_info']['id'] == customerID) {
                isCanceled = true;
                otherUser = workoutRequest['recipient_info'];
              } else if (!isSent &&
                  workoutRequest['recipient_info']['id'] == customerID) {
                otherUser = workoutRequest['sender_info'];
              } else {
                return const SizedBox.shrink();
              }
              DateTime dateTime =
                  DateTime.parse(workoutRequest['workout_time']);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomRow(
                    name: otherUser['first_name'],
                    age: otherUser['age'].toString(),
                    rank: otherUser['rank_named'],
                    trainingDuration: otherUser['workout_streak'].toString(),
                    gymName: otherUser['current_gym'],
                    imageUrl: otherUser['profile_picture'],
                    detailsWidth: 0.9 * MediaQuery.of(context).size.width,
                    imageSize: 60,
                    spacebetweenDetailsAndGym: 10,
                    workoutDay: DateFormat('EEEE').format(dateTime),
                    workoutTime: DateFormat('HH:mm').format(dateTime),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: !isCanceled
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.end,
                    children: [
                      if (!isCanceled)
                        ElevatedButton(
                          onPressed: () async {
                            await apiRequests
                                .updateUserSuperpalsWorkoutRequests(requestId,
                                    status: 'Accepted');
                            _loadWorkoutRequests();

                            print(
                                'Workout request accepted for ${otherUser['first_name']}');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 12),
                            primary: const Color(0xFF000000).withAlpha(160),
                          ),
                          child: const Text('Accept',
                              style: TextStyle(
                                color: Color(0xFF00CE18),
                                fontSize: 17,
                              )),
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          await apiRequests.updateUserSuperpalsWorkoutRequests(
                              requestId,
                              status: isCanceled ? 'Canceled' : 'Declined');
                          await _loadWorkoutRequests();
                          print(
                              'Workout request denied for ${otherUser['first_name']}');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 12),
                          primary: const Color(0xFF000000).withAlpha(160),
                        ),
                        child: Text(isCanceled ? 'Cancel' : 'Reject',
                            style: const TextStyle(
                              color: Color(0xFFD80000),
                              fontSize: 17,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              );
            }).toList(),
          )
        : const SizedBox.shrink();
  }
}

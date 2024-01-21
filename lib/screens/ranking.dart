import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:superpal/components/custom_card.dart';
import '../components/common_layout.dart';
import '../components/rankings_list_item.dart';
import '../helpers/api_requests.dart';
import '../helpers/api_service.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final ApiRequests apiRequests =
      ApiRequests(ApiService(), const FlutterSecureStorage());
  List<dynamic> customers = [];
  String? currentUserID;

  @override
  void initState() {
    super.initState();
    fetchCustomersSortedByWorkoutStreak();
  }

  Future<void> fetchCustomersSortedByWorkoutStreak() async {
    try {
      await apiRequests.getCustomersSortedByWorkoutStreak();
      final String? customersString =
          await apiRequests.storage.read(key: 'customers');
      final refreshToken = await apiRequests.storage.read(key: 'refresh');

      final Map<String, dynamic> decodedToken =
          JwtDecoder.decode(refreshToken!);
      currentUserID = decodedToken['customer_id'];
      if (customersString != null) {
        final List<dynamic> fetchedCustomers = jsonDecode(customersString);

        setState(() {
          customers = fetchedCustomers;
        });
      } else {
        print('Stored customers data is null');
      }
    } catch (error) {
      print('Error fetching customers: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      imageUrl: 'assets/images/rankings_background_cropped.png',
      selectedIndex: 4,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 54),
            const Text(
              'HEROES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 29),
            const CustomCard(
              imagePath: 'assets/images/questionmarks_cropped.jpg',
              textContent: 'WHAT MAKES ME A HERO ?',
              routeName: '/rankingExplained',
            ),
            const SizedBox(height: 24),
            const Text(
              'TABLE OF HEROES',
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Let\'s see where you are standing at',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 31),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.34,
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  bool isUser = currentUserID == customer['id'].toString();

                  return Column(
                    children: [
                      CustomRow(
                        number: (index + 1).toString(),
                        name: customer['first_name'] ?? '',
                        age: customer['age']?.toString() ?? '',
                        rank: customer['rank'] ?? '',
                        trainingDuration:
                            customer['workout_streak']?.toString() ?? '',
                        gymName: customer['current_gym'] ?? '',
                        imageUrl: customer['profile_picture'] ?? '',
                        isUser: isUser,
                      ),
                      const SizedBox(height: 18),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

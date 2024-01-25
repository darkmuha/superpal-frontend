import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../components/common_layout.dart';
import '../../components/rankings_list_item.dart';
import '../../helpers/api_requests.dart';
import '../../helpers/api_service.dart';

class MySuperPalsScreen extends StatefulWidget {
  const MySuperPalsScreen({super.key});

  @override
  State<MySuperPalsScreen> createState() => _MySuperPalsScreenState();
}

class _MySuperPalsScreenState extends State<MySuperPalsScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();
  late final ApiRequests apiRequests;
  List<dynamic>? userSuperPals;

  @override
  void initState() {
    super.initState();
    apiRequests = ApiRequests(apiService, storage);
    _loadSuperpals();
  }

  Future<void> _loadSuperpals() async {
    try {
      final refreshToken = await storage.read(key: 'refresh');

      if (refreshToken != null) {
        final Map<String, dynamic> decodedToken =
            JwtDecoder.decode(refreshToken);
        final customerID = decodedToken['customer_id'];

        await apiRequests.getUserSuperpals(customerID);

        final userSuperPalsUncoded = await storage.read(key: 'superpals');

        if (userSuperPalsUncoded != null) {
          userSuperPals = jsonDecode(userSuperPalsUncoded);
          setState(() {});
        } else {
          print('Error: userSuperPalsUncoded is null');
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
      imageUrl: 'assets/images/superpals_background_cropped.png',
      selectedIndex: 2,
      body: buildBody(),
    );
  }

  Widget buildBody() {
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
          const SizedBox(height: 16),
          SingleChildScrollView(
            child: userSuperPals != null
                ? Center(
                    child: SizedBox(
                      width: 0.9 * MediaQuery.of(context).size.width,
                      height: 0.65 * MediaQuery.of(context).size.height,
                      child: _buildSuperPalsList(),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSuperPalsList() {
    return ListView.builder(
      itemCount: userSuperPals!.length,
      itemBuilder: (context, index) {
        final superPal = userSuperPals![index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/workout_planning', arguments: superPal);
                print(
                    'Plan a Workout button clicked for ${superPal['first_name']}');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 57, vertical: 7),
                primary: const Color(0xFF222222),
              ),
              child: const Text('Plan a Workout',
                  style: TextStyle(
                    color: Color(0xFF00CE18),
                    fontSize: 17,
                  )),
            ),
            const SizedBox(height: 30),
          ],
        );
      },
    );
  }
}

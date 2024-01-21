import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_service.dart';

class ApiRequests {
  final ApiService apiService;
  final FlutterSecureStorage storage;

  ApiRequests(this.apiService, this.storage);

  Future<void> getUserDetails(String customerID) async {
    try {
      final userDetailsResponse = await apiService.getUserDetails(customerID);

      if (userDetailsResponse.statusCode == 200) {
        final userDetails = userDetailsResponse.data;
        // print('User details: $userDetails');
        await saveSecurelyMap('userDetails', userDetails);
      } else {
        print('Error fetching user details: ${userDetailsResponse.statusCode}');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }

  Future<void> getUserSuperpals(String customerID) async {
    try {
      final superpalsResponse = await apiService.getUserSuperpals(customerID);

      if (superpalsResponse.statusCode == 200) {
        final superpals = superpalsResponse.data;
        // print('User superpals: $superpals');
        await saveSecurelyList('superpals', superpals);
      } else {
        print('Error fetching user superpals: ${superpalsResponse.statusCode}');
      }
    } catch (error) {
      print('Error fetching user superpals: $error');
    }
  }

  Future<void> getUserSuperpalsWorkoutRequests(String customerID) async {
    try {
      final superpalsWorkoutRequestsResponse =
          await apiService.getUserSuperpalsWorkoutRequests(customerID);

      if (superpalsWorkoutRequestsResponse.statusCode == 200) {
        final workoutRequests = superpalsWorkoutRequestsResponse.data;
        // print('User superpals workout requests: $workoutRequests');
        await saveSecurelyList('superpals_requests', workoutRequests);
      } else {
        print(
            'Error fetching user superpals requests: ${superpalsWorkoutRequestsResponse.statusCode}');
      }
    } catch (error) {
      print('Error fetching user superpals requests: $error');
    }
  }

  Future<void> getCustomersSortedByWorkoutStreak() async {
    try {
      final customersSortedByWorkoutStreakResponse =
          await apiService.getCustomersSortedByWorkoutStreak();

      if (customersSortedByWorkoutStreakResponse.statusCode == 200) {
        final workoutRequests = customersSortedByWorkoutStreakResponse.data;
        // print('customers sorted by workout streak: $workoutRequests');
        await saveSecurelyList('customers', workoutRequests);
      } else {
        print(
            'Error fetching user superpals requests: ${customersSortedByWorkoutStreakResponse.statusCode}');
      }
    } catch (error) {
      print('Error fetching user superpals requests: $error');
    }
  }

  Future<void> getFilteredWorkouts(String intensity, String difficulty) async {
    try {
      final filteredWorkoutsResponse =
          await apiService.getFilteredWorkouts(intensity, difficulty);

      if (filteredWorkoutsResponse.statusCode == 200) {
        final filteredWorkouts = filteredWorkoutsResponse.data;
        // print('Filtered workouts: $filteredWorkouts');
        await saveSecurelyList('workouts', filteredWorkouts);
      } else {
        print(
            'Error fetching filtered workouts: ${filteredWorkoutsResponse.statusCode}');
      }
    } catch (error) {
      print('Error fetching filtered workouts: $error');
    }
  }

  Future<void> saveSecurelyList(String key, List<dynamic> value) async {
    await storage.write(key: key, value: jsonEncode(value));
  }

  Future<void> saveSecurelyMap(String key, Map<String, dynamic> value) async {
    await storage.write(key: key, value: jsonEncode(value));
  }
}

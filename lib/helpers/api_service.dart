import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as GET;
import 'package:superpal/helpers/constants.dart';

class ApiService {
  late Dio _dio;
  bool _isRefreshing = false;

  ApiService() {
    _dio = Dio();
    _setupInterceptors();
  }

  Dio get dio => _dio;

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        const FlutterSecureStorage storage = FlutterSecureStorage();
        String? accessToken = await storage.read(key: 'access');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if (!_isRefreshing &&
            e.response != null &&
            (e.response!.statusCode == 403 || e.response!.statusCode == 401)) {
          _isRefreshing = true;
          if (await _refreshToken()) {
            RequestOptions retryOptions = e.requestOptions;
            const FlutterSecureStorage storage = FlutterSecureStorage();
            String? newAccessToken = await storage.read(key: 'access');
            if (newAccessToken != null) {
              retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            }

            Options retryDioOptions = Options(
              method: retryOptions.method,
              headers: retryOptions.headers,
            );
            await _dio.request(retryOptions.path,
                options: retryDioOptions, data: retryOptions.data);
          } else {
            print('Token refresh failed. Logging out...');
            const FlutterSecureStorage storage = FlutterSecureStorage();
            await storage.deleteAll();
            GET.Get.toNamed('/welcome');
          }
        }

        return handler.next(e);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      String? refreshToken = await storage.read(key: 'refresh');
      if (refreshToken != null) {
        Response refreshResponse = await _dio.post(
          '${AppConstants.apiUrl}/authentication/token/refresh/',
          data: {'refresh': refreshToken},
        );

        if (refreshResponse.statusCode == 200) {
          var refreshedTokens = refreshResponse.data;
          await storage.write(key: 'access', value: refreshedTokens['access']);
          await storage.write(
              key: 'refresh', value: refreshedTokens['refresh']);
          return true;
        }
      } else {
        GET.Get.toNamed('/welcome');
      }
    } catch (error) {
      print('Token refresh error: $error');
    }
    return false;
  }

  Future<Response> getUserDetails(String customerID) {
    return dio.get('${AppConstants.apiUrl}/customers/$customerID/');
  }

  Future<Response> getUserSuperpals(String customerID) {
    return dio.get('${AppConstants.apiUrl}/superpals/customer/$customerID/');
  }

  Future<Response> getProgress(String customerID) {
    return dio.get('${AppConstants.apiUrl}/customers/progress/$customerID/');
  }

  Future<Response> getUserSuperpalsWorkoutRequests(
    String customerID,
    String status,
  ) {
    return dio.get(
        '${AppConstants.apiUrl}/superpals/workout_request/customer/$customerID/',
        queryParameters: {'status': status});
  }

  Future<Response> updateUserSuperpalsWorkoutRequests(
    String request_id,
    String status,
  ) {
    return dio.put(
        '${AppConstants.apiUrl}/superpals/workout_request/$request_id/',
        data: {'status': status});
  }

  Future<Response> getFilteredWorkouts(
    String intensity,
    String difficulty,
  ) {
    return dio.get('${AppConstants.apiUrl}/workouts/',
        queryParameters: {'intensity': intensity, 'difficulty': difficulty});
  }

  Future<Response> postProgress(
    String customerID,
    String progressImage,
  ) {
    return dio.post(
      '${AppConstants.apiUrl}/customers/progress/',
      data: {
        'user': customerID,
        'progress_image': progressImage,
      },
    );
  }

  Future<Response> postWorkoutRequest(
    String customerID,
    String superPalID,
    String workoutTime,
  ) {
    return dio.post(
      '${AppConstants.apiUrl}/superpals/workout_request/',
      data: {
        'recipient_id': superPalID,
        'sender_id': customerID,
        'workout_time': workoutTime,
      },
    );
  }

  Future<Response> getCustomersSortedByWorkoutStreak() {
    return dio.get('${AppConstants.apiUrl}/customers/');
  }

  Future<Response> updateCustomer(
    String customerID, {
    String? intensity,
    String? difficulty,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        if (intensity != null) 'workout_intensity': intensity,
        if (difficulty != null) 'workout_difficulty': difficulty,
      };

      final response = await _dio.put(
        '${AppConstants.apiUrl}/customers/$customerID/',
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      return response;
    } catch (error) {
      throw Exception('Error updating customer: $error');
    }
  }
}

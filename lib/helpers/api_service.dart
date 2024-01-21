import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:superpal/helpers/constants.dart';

class ApiService {
  late Dio _dio;

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
        if (e.response != null &&
            (e.response!.statusCode == 403 || e.response!.statusCode == 401)) {
          if (await _refreshToken()) {
            RequestOptions retryOptions = e.requestOptions;
            const FlutterSecureStorage storage = FlutterSecureStorage();
            String? newAccessToken = await storage.read(key: 'access');
            retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            Options retryDioOptions = Options(
              method: retryOptions.method,
              headers: retryOptions.headers,
            );

            return handler.next((await _dio.request(retryOptions.path,
                options: retryDioOptions,
                data: retryOptions.data)) as DioException);
          } else {
            print('Token refresh failed. Logging out...');
            const FlutterSecureStorage storage = FlutterSecureStorage();
            storage.deleteAll();
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

  Future<Response> getUserSuperpalsWorkoutRequests(String customerID) {
    return dio.get(
        '${AppConstants.apiUrl}/superpals/workout_request/customer/$customerID/');
  }

  Future<Response> getFilteredWorkouts(String intensity, String difficulty) {
    return dio.get('${AppConstants.apiUrl}/workouts/',
        queryParameters: {'intensity': intensity, 'difficulty': difficulty});
  }

  Future<Response> getCustomersSortedByWorkoutStreak() {
    return dio.get('${AppConstants.apiUrl}/customers/');
  }
}

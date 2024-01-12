import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:superpal/helpers/constants.dart';

// Tried creating the apiservice
// thingy that adds headers but i didn't test it it yet
// I will work on it last.

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
        // Add token to headers
        const FlutterSecureStorage storage = FlutterSecureStorage();
        String? accessToken = await storage.read(key: 'access');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onResponse:
          (Response response, ResponseInterceptorHandler handler) async {
        const FlutterSecureStorage storage = FlutterSecureStorage();

        if (response.statusCode == 403) {
          // Token refresh logic
          if (await _refreshToken()) {
            RequestOptions retryOptions = response.requestOptions;
            String? newAccessToken = await storage.read(key: 'access');
            retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            Options retryDioOptions = Options(
              method: retryOptions.method,
              headers: retryOptions.headers,
            );

            handler.resolve(await _dio.request(retryOptions.path,
                options: retryDioOptions, data: retryOptions.data));
          } else {
            print('Token refresh failed. Logging out...');
            storage.deleteAll();
          }
        }
        return handler.next(response);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      String? refreshToken = await storage.read(key: 'refresh');

      if (refreshToken != null) {
        Response refreshResponse = await _dio.post(
          '${AppConstants.apiUrl}/token/refresh',
          data: {'refresh': refreshToken},
        );

        if (refreshResponse.statusCode == 200) {
          var refreshedTokens = refreshResponse.data;
          await storage.write(key: 'access', value: refreshedTokens['access']);
          await storage.write(
              key: 'refresh', value: refreshedTokens['refresh']);
          print('Token refresh successful');
          return true;
        }
      }
    } catch (error) {
      print('Token refresh error: $error');
    }
    return false;
  }
}

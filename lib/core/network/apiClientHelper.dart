import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:keytype/core/helper/base_brain.dart';
import 'package:keytype/utils/env_functions.dart';
import 'dart:developer' as l;
import '../storage/local_storage_manager.dart';

class ApiClientHelper {
  static Dio? _instance;

  /// Creates and configures a Dio instance with authentication and error handling
  static Dio createDioInstance({
    bool? refreshToken,
    bool useBasicCredintials = false,
  }) {
    return _instance ??= _createDioWithAuth(
      useBasicCredintials: useBasicCredintials,
    );
  }

  static Dio _createDioWithAuth({required bool useBasicCredintials}) {
      final String baseUrl = DotEnvUtils.getApiBaseUrl;
      final Dio dio = Dio(
        BaseOptions(
          receiveTimeout: const Duration(seconds: 15),
          connectTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 30),
          baseUrl: baseUrl,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (final options, final handler) async {
            await LocalStorageManager.getInstance().then((val) async {
              if (useBasicCredintials) {
                // Use Basic auth for task APIs
                String credentials = 'rshakeri163@gmail.com:yE:y\$E6T[mc-iHi1';
                List<int> encodedBytes = utf8.encode(credentials);
                String base64Credentials = base64Encode(encodedBytes);
                options.headers['Authorization'] = 'Basic $base64Credentials';
              } else {
                // Use Bearer token for other APIs
                String? token = val.getToken() ?? "";
                String? refreshToken = val.getRefreshToken() ?? "";
                BaseBrain.accessToken = token;
                BaseBrain.refreshToken = refreshToken;
                if (token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                } else {
                  // Fallback to Basic auth if no Bearer token
                  String credentials = 'rshakeri163@gmail.com:yE:y\$E6T[mc-iHi1';
                  List<int> encodedBytes = utf8.encode(credentials);
                  String base64Credentials = base64Encode(encodedBytes);
                  options.headers['Authorization'] = 'Basic $base64Credentials';
                }
              }
            });

            if (kDebugMode) {
              print(
                "Request Authorization: ${options.headers['Authorization']}",
              );
            }
            options.validateStatus = (final status) => status! < 500;
            return handler.next(options);
          },
          onError: (error, handler) {
            if (kDebugMode) {
              debugPrint('Network Error: ${error.message}');
              debugPrint('Status Code: ${error.response?.statusCode}');
            }

            // Let the error bubble up to be handled by the use case layer
            // This removes UI concerns from the network layer
            return handler.reject(error);
          },
          onResponse: (response, handler) async {
            // if (response.statusCode == 403) {
            //   if (kDebugMode) {
            //     print('Access forbidden (403): ${response.data}');
            //   }
            //   // Let the error bubble up to be handled by use case layer
            //   return handler.next(response);
            // }

            // if (response.statusCode == 401) {
            //   if (kDebugMode) {
            //     print('Unauthorized (401): Attempting token refresh');
            //   }

            //   final localStorage = await LocalStorageManager.getInstance();
            //   final accessToken =
            //       localStorage.getString(KeyNameStorage.accessToken) ?? '';
            //   final refreshTokenValue =
            //       localStorage.getString(KeyNameStorage.refreshToken) ?? '';

            //   if (accessToken.isEmpty && refreshTokenValue.isEmpty) {
            //     // User is not logged in, let the error bubble up
            //     return handler.next(response);
            //   }

            //   try {
            //     final result = await dio.post(
            //       '/users/otp/token/refressh/',
            //       data: {'refresh_token': refreshTokenValue},
            //     );

            //     if (result.statusCode == 200) {
            //       final newToken = result.data['access_token'];
            //       final newRefreshToken = result.data['refresh_token'];
            //       await Utils.saveToken(newRefreshToken, newToken);

            //       // Retry the original request with new token
            //       response.requestOptions.headers['Authorization'] =
            //           'Bearer $newToken';
            //       return handler
            //           .resolve(await dio.fetch(response.requestOptions));
            //     }
            //   } catch (e) {
            //     if (kDebugMode) {
            //       print('Token refresh failed: $e');
            //     }
            //   }

            //   // Token refresh failed, let the error bubble up
            //   return handler.next(response);
            // }

            return handler.next(response);
          },
        ),
      );

      if (kDebugMode) {
        dio.interceptors.add(
          LogInterceptor(
            responseBody: true,
            requestBody: true,
            logPrint: (object) {
              l.log(object.toString());
            },
          ),
        );
      }
      return dio;
  }
}

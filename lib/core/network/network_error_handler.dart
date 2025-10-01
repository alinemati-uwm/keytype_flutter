import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Handles network errors and provides standardized error responses
/// Separated from UI concerns for better architecture
class NetworkErrorHandler {
  /// Handles DioExceptions and returns user-friendly error messages
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection error. Please check your internet connection and try again.';

      case DioExceptionType.badResponse:
        return _handleStatusCodeError(
            error.response?.statusCode, error.response?.data);

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      case DioExceptionType.unknown:
      default:
        if (kDebugMode) {
          print('Unknown DioException: ${error.message}');
        }
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Handles HTTP status code errors
  static String _handleStatusCodeError(int? statusCode, dynamic responseData) {
    switch (statusCode) {
      case 400:
        return _extractErrorMessage(responseData) ??
            'Bad request. Please check your input.';
      case 401:
        return 'Authentication required. Please log in again.';
      case 403:
        return _extractErrorMessage(responseData) ?? 'Access denied.';
      case 404:
        return 'Resource not found.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
      case 503:
      case 504:
        return 'Service temporarily unavailable. Please try again later.';
      default:
        return _extractErrorMessage(responseData) ??
            'An error occurred. Please try again.';
    }
  }

  /// Extracts error message from response data
  static String? _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is Map<String, dynamic>) {
      return responseData['detail'] ??
          responseData['message'] ??
          responseData['error'];
    }

    if (responseData is String) {
      return responseData;
    }

    return null;
  }

  /// Checks if error indicates insufficient credits
  static bool isInsufficientCredit(dynamic responseData) {
    final message = _extractErrorMessage(responseData);
    return message?.toLowerCase().contains('insufficient credit') ?? false;
  }

  /// Checks if error indicates token expiration
  static bool isTokenExpired(int? statusCode) {
    return statusCode == 401;
  }

  /// Checks if error indicates access denied (403)
  static bool isAccessDenied(int? statusCode) {
    return statusCode == 403;
  }
}

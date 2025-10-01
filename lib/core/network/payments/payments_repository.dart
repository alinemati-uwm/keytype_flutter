import 'package:dio/dio.dart';
import '../apiClientHelper.dart';
import '../apiEndPoints.dart';

/// Payments Repository - Handles only HTTP requests for payments functionality
/// Returns raw Response objects without business logic
class PaymentsRepository {
  late final Dio _dio;

  PaymentsRepository() {
    _dio = ApiClientHelper.createDioInstance();
  }

  Future<Response> subscriptions(bool isMonthly) => _dio.get(
        ApiEndPoint.subscriptions,
        queryParameters: {'monthly': isMonthly},
      );

  Future<Response> createPayment(int planId) => _dio.post(
        ApiEndPoint.createPayment,
        data: {
          'plan_id': planId,
          'payment_type': 'credit_card',
        },
      );
}

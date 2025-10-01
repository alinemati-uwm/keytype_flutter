import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';

import '../../init/dependency_injection.dart';
import '../../models/error_utils/error.dart';
import '../../models/credit_model/plan_model.dart';
import '../../models/credit_model/payment_response_model.dart';
import '../network_error_handler.dart';
import 'payments_repository.dart';

/// Payments API Calls - Handles business logic and error handling for payments functionality
/// Returns Either<Failure, T> for functional error handling
class PaymentsApiCalls {
  final _repository = getIt<PaymentsRepository>();

  /// Handles DioExceptions and converts them to Either
  Either<Failure, T> _handleDioError<T>(DioException error) {
    final message = NetworkErrorHandler.handleDioError(error);
    return Left(Failure(message, error.response?.statusCode));
  }

  /// Handles general exceptions
  Either<Failure, T> _handleGeneralError<T>(Object error) {
    log('Unexpected error in PaymentsApiCalls: $error');
    return Left(Failure('An unexpected error occurred', null));
  }

  Future<Either<Failure, List<PlanModel>>> subscriptions(bool isMonthly) async {
    try {
      final result = await _repository.subscriptions(isMonthly);

      if (result.statusCode == 200) {
        final List<dynamic> list = result.data['plans'];
        final plans =
            list.map((element) => PlanModel.fromJson(element)).toList();
        return Right(plans);
      } else {
        return Left(Failure(
          NetworkErrorHandler.handleDioError(
            DioException(
              requestOptions: result.requestOptions,
              response: result,
            ),
          ),
          result.statusCode,
        ));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, PaymentResponseModel>> createPayment(int id) async {
    try {
      final result = await _repository.createPayment(id);

      if (result.statusCode == 200) {
        final data = PaymentResponseModel.fromJson(result.data);
        return Right(data);
      } else {
        return Left(Failure(
          NetworkErrorHandler.handleDioError(
            DioException(
              requestOptions: result.requestOptions,
              response: result,
            ),
          ),
          result.statusCode,
        ));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }
}

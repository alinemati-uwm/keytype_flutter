import 'dart:io';
import 'dart:developer';
import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';

import '../../init/dependency_injection.dart';
import '../../models/error_utils/error.dart';
import '../../models/user_model/user_model.dart';
import '../network_error_handler.dart';
import 'user_repository.dart';

/// User API Calls - Handles business logic and error handling for user functionality
/// Returns Either<Failure, T> for functional error handling
class UserApiCalls {
  final _repository = getIt<UserRepository>();

  /// Handles DioExceptions and converts them to Either
  Either<Failure, T> _handleDioError<T>(DioException error) {
    final message = NetworkErrorHandler.handleDioError(error);
    return Left(Failure(message, error.response?.statusCode));
  }

  /// Handles general exceptions
  Either<Failure, T> _handleGeneralError<T>(Object error) {
    log('Unexpected error in UserApiCalls: $error');
    return Left(Failure('An unexpected error occurred', null));
  }

  Future<Either<Failure, UserModel>> getUserInfo() async {
    try {
      final response = await _repository.getUserInfo();
      if (response.statusCode == 200) {
        log("It is successssss");
        final userModel = UserModel.fromJson(response.data['user']);
        return Right(userModel);
      } else {
        log(
          "Failed Due to -> ${response.statusMessage}, ${response.requestOptions.headers}",
        );
        return Left(
          Failure(
            NetworkErrorHandler.handleDioError(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
              ),
            ),
            response.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> uploadImage(File file) async {
    try {
      final result = await _repository.uploadImage(file);

      if (result.statusCode == 200) {
        return Right(result.data['profile_image'] ?? '');
      } else {
        return Left(
          Failure(
            NetworkErrorHandler.handleDioError(
              DioException(
                requestOptions: result.requestOptions,
                response: result,
              ),
            ),
            result.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, UserModel>> updateAccountInfo(
    String firstName,
    String lastName,
  ) async {
    try {
      final result = await _repository.updateAccountInfo(firstName, lastName);

      if (result.statusCode == 200) {
        return Right(UserModel.fromJson(result.data));
      } else {
        return Left(
          Failure(
            NetworkErrorHandler.handleDioError(
              DioException(
                requestOptions: result.requestOptions,
                response: result,
              ),
            ),
            result.statusCode,
          ),
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }
}

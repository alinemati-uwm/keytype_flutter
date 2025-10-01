import 'package:either_dart/either.dart';
import 'package:dio/dio.dart';
import 'package:keytype/core/helper/base_brain.dart';
import 'package:keytype/core/storage/local_storage_manager.dart';
import 'dart:developer';

import '../../init/dependency_injection.dart';
import '../../helper/utils.dart';
import '../../models/error_utils/error.dart';
import '../../models/login_model/login_response_model.dart';
import '../../models/user_model/user_model.dart';
import '../network_error_handler.dart';
import 'auth_repository.dart';

/// Auth API Calls - Handles business logic and error handling for authentication
/// Returns Either<Failure, T> for functional error handling
class AuthApiCalls {
  final _repository = getIt<AuthRepository>();

  /// Handles DioExceptions and converts them to Either
  Either<Failure, T> _handleDioError<T>(DioException error) {
    final message = NetworkErrorHandler.handleDioError(error);
    return Left(Failure(message, error.response?.statusCode));
  }

  /// Handles general exceptions
  Either<Failure, T> _handleGeneralError<T>(Object error) {
    log('Unexpected error in AuthApiCalls: $error');
    return Left(Failure('An unexpected error occurred', null));
  }

  Future<Either<Failure, String>> requestLoginOTP(
      {required String email}) async {
    try {
      final result = await _repository.requestLoginOTP(email: email);
      if (result.statusCode == 200) {
        return Right(
            result.data['detail'] ?? "OTP sent to your email successfully");
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(DioException(
            requestOptions: result.requestOptions, response: result));
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (error) {
      return _handleDioError(error);
    } catch (error) {
      return _handleGeneralError(error);
    }
  }

  Future<Either<Failure, String>> loginWithOPT(
      {required String email, required String otp}) async {
    try {
      final result = await _repository.loginWithOTP(email: email, otp: otp);
      if (result.statusCode == 200) {
        final responseModel = LoginResponseModel(
          refreshToken: result.data['refresh_token'] as String,
          accessToken: result.data['access_token'] as String,
        );
        await Utils.saveID(result.data['user']['id']);
        await Utils.saveToken(
            responseModel.refreshToken, responseModel.accessToken);
        await Utils.saveDevicePrefrences(
            id: result.data['device']['id'] ?? "",
            deviceName: result.data['device']['device_name'] ?? "",
            device_id: result.data['device']['device_id'] ?? "");
        return Right(result.data['detail'] ?? "Login successfull");
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(DioException(
            requestOptions: result.requestOptions, response: result));
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (error) {
      return _handleDioError(error);
    } catch (error) {
      return _handleGeneralError(error);
    }
  }

  Future<Either<Failure, LoginResponseModel>> signIn(
      UserModel userModel) async {
    try {
      final result = await _repository.signIn(userModel);

      if (result.statusCode == 200) {
        log("\n\nres:${result.data}\n\n");
        // Parse the response directly as it contains refresh and access tokens
        final responseModel = LoginResponseModel(
          refreshToken: result.data['refresh'] as String,
          accessToken: result.data['access'] as String,
        );
        await Utils.saveToken(
            responseModel.refreshToken, responseModel.accessToken);
        await Utils.saveID(result.data['user']['id'].toString());
        return Right(responseModel);
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> verifyEmail(
      {required String email, required String otp}) async {
    try {
      final result = await _repository.verifyEmailOTP(email: email, otp: otp);
      if (result.statusCode == 200) {
        return Right(result.data);
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, UserModel>> signUp(UserModel userModel) async {
    try {
      final result = await _repository.signUp(userModel);

      if (result.statusCode == 201 || result.statusCode == 200) {
        final user = UserModel.fromJson(result.data);
        return Right(user);
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> logout({required String refreshToken}) async {
    try {
      final result = await _repository.logout(refreshToken: refreshToken);
      if (result.statusCode == 200 || result.statusCode == 205) {
        return Right(result.data);
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> resendVerificationEmail(
      {required String email}) async {
    try {
      final result = await _repository.resendVerificationEmail(email: email);
      if (result.statusCode == 200) {
        return Right(result.data);
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> autoRefreshToken(
      {required String refreshToken}) async {
    try {
      final result = await _repository.refreshToken(refreshToken: refreshToken);
      log("api refresh res: ${result.statusMessage}");
      if (result.statusCode == 200) {
        await LocalStorageManager.getInstance().then((storage) async {
          await storage.saveRefreshToken(result.data['refresh_token']);
          await storage.saveToken(result.data['access_token']);
          BaseBrain.accessToken= result.data['access_token'];
          BaseBrain.refreshToken= result.data['refresh_token'];
        });
        return Right('Token refreshed successfully!');
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> forgetPassword(String email) async {
    try {
      final result = await _repository.forgetPassword(email);

      if (result.statusCode == 200) {
        return Right(result.data['message'] ?? 'Password reset email sent');
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> requestResetPassword(
      {required String email}) async {
    try {
      final result = await _repository.requestPasswordReset(email: email);
      if (result.statusCode == 200) {
        return Right(result.data['detail'] ??
            "Please check your inbox. We have sent you a verification code.");
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(
          DioException(
            requestOptions: result.requestOptions,
            response: result,
          ),
        );
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> confirmPasswordReset({
    required String uid,
    required String token,
    required String newPassword,
  }) async {
    try {
      final result = await _repository.confirmPasswordReset(
        uid: uid,
        token: token,
        newPassword: newPassword,
      );
      if (result.statusCode == 200) {
        return Right(result.data['detail'] ?? 'Password reset confirmed!');
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(DioException(
          requestOptions: result.requestOptions,
          response: result,
        ));
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> confirmResetPasswordOTP({
    required String email,
    required String otp,
  }) async {
    try {
      final result = await _repository.verifyPasswordResetOTP(
        email: email,
        otp: otp,
      );
      if (result.statusCode == 200) {
        return Right(result.data['detail'] ?? 'OTP confirmed!');
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(DioException(
          requestOptions: result.requestOptions,
          response: result,
        ));
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await _repository.verifyResetPasswordOTP(
          email: email,
          otp: otp,
          newPassword: password,
          confirmPassword: passwordConfirmation);
      if (result.statusCode == 200 || result.statusCode == 201) {
        return Right(
            result.data['detail'] ?? 'Your password has been changed!');
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(DioException(
          requestOptions: result.requestOptions,
          response: result,
        ));
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, String>> updatePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final result = await _repository.updatePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
          confirmNewPassword: newPassword);
      if (result.statusCode == 200) {
        return Right(result.data['detail'] ?? 'Password updated successfully!');
      } else {
        final errorMessage = NetworkErrorHandler.handleDioError(DioException(
          requestOptions: result.requestOptions,
          response: result,
        ));
        return Left(Failure(errorMessage, result.statusCode));
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleGeneralError(e);
    }
  }

  Future<Either<Failure, LoginResponseModel>> callGoogleAuth(
      String googleAccessToken) async {
    try {
      final result = await _repository.googleAuth(googleAccessToken);
      if (result.statusCode == 200) {
        // Parse the response directly as it contains refresh and access tokens
        final responseModel = LoginResponseModel(
          refreshToken: result.data['refresh'] as String,
          accessToken: result.data['access'] as String,
        );
        await Utils.saveToken(
            responseModel.refreshToken, responseModel.accessToken);
        return Right(responseModel);
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

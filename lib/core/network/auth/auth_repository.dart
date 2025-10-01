import 'package:dio/dio.dart';
import 'package:keytype/core/network/auth/authEndPoints.dart';
import '../apiClientHelper.dart';
import '../../models/user_model/user_model.dart';

/// Auth Repository - Handles only HTTP requests for authentication
/// Returns raw Response objects without business logic
class AuthRepository {
  late final Dio _dio;

  AuthRepository() {
    _dio = ApiClientHelper.createDioInstance();
  }

  Future<Response> signUp(final UserModel userModel) =>
      _dio.post(AuthEndPoint.signUP,
          data: {...userModel.toJson(), 'terms_accepted': true});

  Future<Response> verifyEmailOTP(
          {required String email, required String otp}) =>
      _dio.post(AuthEndPoint.verifyEmail,
          data: {'email': email, 'otp_code': otp});

  Future<Response> signIn(final UserModel userModel) =>
      _dio.post(AuthEndPoint.signIN, data: userModel.toJson());

  Future<Response> requestLoginOTP(
          {required String email}) =>
      _dio.post(AuthEndPoint.requestLoginWithOTP, data: {
        'email': email,
      });

  Future<Response> loginWithOTP({
    required String email,
    required String otp,
  }) =>
      _dio.post(AuthEndPoint.loginWithOTP, data: {
        'email': email,
        'otp_code': otp,
      });

  Future<Response> forgetPassword(final String email) =>
      _dio.post(AuthEndPoint.forgetPassword, data: {'email': email});

  Future<Response> refreshToken({required String refreshToken}) =>
      _dio.post(AuthEndPoint.refreshToken, data: {'refresh_token': refreshToken});

  Future<Response> logout({required String refreshToken}) =>
      _dio.post(AuthEndPoint.logout, data: {'refresh': refreshToken});

  Future<Response> resendVerificationEmail({required String email}) =>
      _dio.post(AuthEndPoint.resendVerificationEmail, data: {'email': email});

  Future<Response> requestPasswordReset({required String email}) =>
      _dio.post(AuthEndPoint.forgetPassword, data: {'email': email});

  Future<Response> verifyPasswordResetOTP(
          {required String email, required String otp}) =>
      _dio.post(AuthEndPoint.verifyResetPasswordOTP,
          data: {'email': email, 'otp_code': otp});

  Future<Response> verifyResetPasswordOTP(
          {required String email,
          required String otp,
          required String newPassword,
          required String confirmPassword}) =>
      _dio.post(AuthEndPoint.confirmResetPasswordOTP, data: {
        'email': email,
        'otp_code': otp,
        'new_password': newPassword,
        'new_password_confirm': confirmPassword
      });

  Future<Response> confirmPasswordReset({
    required String uid,
    required String token,
    required String newPassword,
  }) async =>
      _dio.post(AuthEndPoint.confirmPasswordReset, data: {
        'uid': uid,
        'token': token,
        'new_password1': newPassword,
        'new_password2': newPassword
      });

  Future<Response> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async =>
      _dio.post(
        AuthEndPoint.setNewPassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'new_password_confirm': confirmNewPassword,
        },
      );

  Future<Response> googleAuth(String googleAccessToken) async {
    // Clean the token
    googleAccessToken = googleAccessToken.replaceAll(' ', '');

    return _dio.post(
      AuthEndPoint.authGoogle,
      data: {'access_token': googleAccessToken},
    );
  }
}

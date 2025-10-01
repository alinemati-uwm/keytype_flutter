class AuthEndPoint {
  static const String signUP = '/users/register/';
  static const String verifyEmail = '/users/email/verify/';
  static const String signIN = '/users/login/';
  static const String logout = '/users/logout/';
  static const String requestLoginWithOTP = '/users/otp/login/request/';
  static const String loginWithOTP = '/users/otp/login/';
  static const String forgetPassword = '/users/password/reset/';
  static const String verifyResetPasswordOTP = '/users/password/reset/otp/verify/';
  static const String confirmResetPasswordOTP = '/users/password/reset/otp/';
  static const String resendVerificationEmail = '/users/resend-confirmation/';
  static const String refreshToken = '/users/otp/token/refresh/';
  static const String authGoogle = '/users/social/google/';
  static const String confirmPasswordReset = '/users/password/reset/confirm/';
  static const String setNewPassword = '/users/password/update/';
}
import 'package:get/get.dart';
import 'package:keytype/core/init/dependency_injection.dart';
import 'package:keytype/core/network/auth/auth_api_calls.dart';
import '../../../../components/dialogs/toast_dialogs.dart';
import '../reset_password/reset_password_screen.dart';

class ConfirmResetPasswordController extends GetxController {
  // Loading and state management
  final isLoading = false.obs;
  final hasError = false.obs;
  final isSuccess = false.obs;
  final errorMessage = ''.obs;
  
  // OTP management
  final otpCode = ''.obs;
  final isResendLoading = false.obs;
  
  // Email for API calls
  late String email;
  
  // API service
  final authApiCalls = getIt<AuthApiCalls>();

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments if passed
    if (Get.arguments != null && Get.arguments is String) {
      email = Get.arguments as String;
    }
  }

  /// Sets the email for OTP verification
  void setEmail(String emailAddress) {
    email = emailAddress;
  }

  /// Validates OTP format
  String? validateOTP(String otp) {
    if (otp.isEmpty) {
      return 'Please enter the verification code';
    }
    
    if (otp.length != 5) {
      return 'Verification code must be 5 digits';
    }
    
    // Check if all characters are digits
    if (!RegExp(r'^\d{5}$').hasMatch(otp)) {
      return 'Verification code must contain only numbers';
    }
    
    return null;
  }

  /// Handles OTP input changes
  void onOTPChanged(String otp) {
    otpCode.value = otp;
    
    // Reset error state when user starts typing
    if (hasError.value) {
      hasError.value = false;
      errorMessage.value = '';
    }
  }

  /// Verifies the OTP with the API
  Future<void> verifyOTP(String otp) async {
    // Validate OTP format
    final otpError = validateOTP(otp);
    if (otpError != null) {
      _showError(otpError);
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Call API to verify OTP
      final result = await authApiCalls.confirmResetPasswordOTP(
        email: email,
        otp: otp,
      );

      result.fold(
        (failure) {
          // Handle API error
          _showError(failure.message ?? 'Invalid verification code. Please try again.');
        },
        (successMessage) {
          // Show success state
          isSuccess.value = true;
          
          // Show success message
          ToastDialogs.showSuccessNotification(
            message: 'Verification successful!',
          );
          
          // Navigate to update password screen after a short delay
          Future.delayed(const Duration(milliseconds: 1000), () {
            Get.to(() => ResetPasswordScreen(email: email, otp: otp));
          });
        },
      );
    } catch (e) {
      // Handle unexpected errors
      _showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Resends the OTP
  Future<void> resendOTP() async {
    try {
      isResendLoading.value = true;

      // Call API to resend OTP (using the same requestResetPassword endpoint)
      final result = await authApiCalls.requestResetPassword(email: email);

      result.fold(
        (failure) {
          // Handle API error
          ToastDialogs.showErrorIconNotification(
            message: failure.message ?? 'Failed to resend code. Please try again.',
          );
        },
        (successMessage) {
          // Show success message
          ToastDialogs.showSuccessNotification(
            message: 'Verification code sent successfully!',
          );
          
          // Reset states
          hasError.value = false;
          isSuccess.value = false;
          errorMessage.value = '';
          otpCode.value = '';
        },
      );
    } catch (e) {
      // Handle unexpected errors
      ToastDialogs.showErrorIconNotification(
        message: 'Failed to resend code. Please try again.',
      );
    } finally {
      isResendLoading.value = false;
    }
  }

  /// Shows error state with message
  void _showError(String message) {
    hasError.value = true;
    isSuccess.value = false;
    errorMessage.value = message;
  }

  /// Clears all states
  void clearStates() {
    hasError.value = false;
    isSuccess.value = false;
    errorMessage.value = '';
    otpCode.value = '';
    isLoading.value = false;
    isResendLoading.value = false;
  }

  /// Gets the current error message or null
  String? get currentErrorMessage {
    return hasError.value ? errorMessage.value : null;
  }
}
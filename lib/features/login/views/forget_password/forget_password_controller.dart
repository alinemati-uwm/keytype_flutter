import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keytype/core/init/dependency_injection.dart';
import 'package:keytype/core/network/auth/auth_api_calls.dart';
import '../../../../components/dialogs/toast_dialogs.dart';
import '../confirm_reset_password.dart/confirm_reset_password_screen.dart';

class ForgetPasswordController extends GetxController {
  // Loading states
  final isLoading = false.obs;
  
  // Form controllers
  final emailController = TextEditingController();
  
  // Focus nodes
  final emailFocusNode = FocusNode();
  
  // API service
  final authApiCalls = getIt<AuthApiCalls>();

  @override
  void onInit() {
    super.onInit();
    // Add listener to focus node for UI updates
    emailFocusNode.addListener(() => update());
  }

  @override
  void onClose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  /// Validates email format
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter your email address';
    }
    
    // Basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Requests password reset via API
  Future<void> requestPasswordReset() async {
    // Validate email
    final emailError = validateEmail(emailController.text.trim());
    if (emailError != null) {
      ToastDialogs.showErrorIconNotification(message: emailError);
      return;
    }

    try {
      isLoading.value = true;

      // Call API to request password reset
      final result = await authApiCalls.requestResetPassword(
        email: emailController.text.trim(),
      );

      result.fold(
        (failure) {
          // Handle API error
          ToastDialogs.showErrorIconNotification(
            message: failure.message ?? 'Failed to send reset code. Please try again.',
          );
        },
        (successMessage) {
          // Show success message
          ToastDialogs.showSuccessNotification(
            message: successMessage,
          );
          
          // Navigate to confirm reset password screen
          Get.to(() => ConfirmResetPasswordScreen(
            email: emailController.text.trim(),
          ));
        },
      );
    } catch (e) {
      // Handle unexpected errors
      ToastDialogs.showErrorIconNotification(
        message: 'An unexpected error occurred. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clears the email field
  void clearEmail() {
    emailController.clear();
  }

  /// Sets email programmatically (useful for testing or pre-filling)
  void setEmail(String email) {
    emailController.text = email;
  }
}
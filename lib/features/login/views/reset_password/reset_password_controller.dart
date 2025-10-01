
import 'package:keytype/core/init/dependency_injection.dart';
import 'package:keytype/core/network/auth/auth_api_calls.dart';
import '../../../../ui_imports.dart';

class ResetPasswordController extends GetxController {
  // Loading states
  final isLoading = false.obs;

  // Form controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Focus nodes
  final newPasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  // Password visibility states
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Email for context (if needed)
  late String email;
  late String otp;

  // API service
  final authApiCalls = getIt<AuthApiCalls>();

  @override
  void onInit() {
    super.onInit();
    // Add listeners to focus nodes for UI updates
    newPasswordFocusNode.addListener(() => update());
    confirmPasswordFocusNode.addListener(() => update());

    // Get email from arguments if passed
    if (Get.arguments != null && Get.arguments is String) {
      email = Get.arguments as String;
      otp = Get.arguments as String;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  /// Sets the email for context
  void setEmail(String emailAddress) {
    email = emailAddress;
  }

  void setotp(String otpCode) {
    otp = otpCode;
  }

  /// Toggles new password visibility
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  /// Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Validates password according to security requirements
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    // Check for sequences like 123, abc, etc.
    if (RegExp(
      r'(012|123|234|345|456|567|678|789|abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)',
      caseSensitive: false,
    ).hasMatch(password)) {
      return 'Password should not contain sequential characters';
    }

    return null;
  }

  /// Validates form inputs
  String? _validateForm() {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      return 'Please enter a new password';
    }

    if (confirmPassword.isEmpty) {
      return 'Please confirm your new password';
    }

    // Validate new password strength
    final passwordError = validatePassword(newPassword);
    if (passwordError != null) {
      return passwordError;
    }

    if (newPassword != confirmPassword) {
      return 'New passwords do not match';
    }

    return null;
  }

  /// Updates the password via API
  Future<void> updatePassword() async {
    // Validate form
    final validationError = _validateForm();
    if (validationError != null) {
      ToastDialogs.showErrorIconNotification(message: validationError);
      return;
    }

    try {
      isLoading.value = true;

      // Call API to update password
      final result = await authApiCalls.resetPassword(
        email: email,
        otp: otp,
        password: newPasswordController.text.trim(),
        passwordConfirmation: confirmPasswordController.text.trim(),
      );

      result.fold(
        (failure) {
          // Handle API error
          ToastDialogs.showErrorIconNotification(
            message: failure.message ??
                'Failed to update password. Please try again.',
          );
        },
        (successMessage) {
          // Show success message
          ToastDialogs.showSuccessNotification(
            message: 'Password updated successfully!',
          );

          // Navigate back to login screen after a delay
          Future.delayed(const Duration(seconds: 2), () {
            Get.offNamedUntil(Routes.login, (route) => false);
          });
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

  /// Clears all form fields
  void clearForm() {
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  /// Checks if password meets specific requirement
  bool checkPasswordRequirement(String password, String requirement) {
    switch (requirement) {
      case 'length':
        return password.length >= 8;
      case 'uppercase':
        return RegExp(r'[A-Z]').hasMatch(password);
      case 'lowercase':
        return RegExp(r'[a-z]').hasMatch(password);
      case 'number':
        return RegExp(r'[0-9]').hasMatch(password);
      case 'special':
        return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
      default:
        return false;
    }
  }

  /// Gets password strength score (0-5)
  int getPasswordStrength(String password) {
    int score = 0;

    if (checkPasswordRequirement(password, 'length')) score++;
    if (checkPasswordRequirement(password, 'uppercase')) score++;
    if (checkPasswordRequirement(password, 'lowercase')) score++;
    if (checkPasswordRequirement(password, 'number')) score++;
    if (checkPasswordRequirement(password, 'special')) score++;

    return score;
  }

  /// Gets password strength text
  String getPasswordStrengthText(String password) {
    final strength = getPasswordStrength(password);

    switch (strength) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Fair';
      case 4:
        return 'Good';
      case 5:
        return 'Strong';
      default:
        return 'Very Weak';
    }
  }

  /// Gets password strength color
  Color getPasswordStrengthColor(String password) {
    final strength = getPasswordStrength(password);

    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}

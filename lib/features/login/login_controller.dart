import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keytype/core/auth/oauth_config.dart';
import 'package:keytype/core/init/dependency_injection.dart';
import 'package:keytype/core/network/auth/auth_api_calls.dart';
import 'package:keytype/ui_imports.dart';
import '../../core/helper/utils.dart';
import '../../core/models/user_model/user_model.dart';
import '../../core/storage/local_storage_manager.dart';
import '../../components/otp/otp_verification_modal.dart';

class LoginController extends GetxController {
  final isSignUp = false.obs;
  final isLoading = false.obs;
  final isLoadingForgetPassword = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final showEmailForm = false.obs; // New state for showing email form
  final isLoadingResendEmail = false.obs; // Add loading state for resend email
  
  // OTP verification states for registration
  final _otpHasError = false.obs;
  final _otpIsSuccess = false.obs;
  final _otpErrorMessage = ''.obs;
  
  // OTP verification states for login
  final _loginOtpHasError = false.obs;
  final _loginOtpIsSuccess = false.obs;
  final _loginOtpErrorMessage = ''.obs;
  final showLoginOtpModal = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  // Focus nodes for styling
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final authApiCalls = getIt<AuthApiCalls>();

  // Pure OAuth configuration using Google Cloud Console
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: OAuthConfig.googleScopes,
    // IMPORTANT: Use Web Client ID for serverClientId, not Android Client ID
    serverClientId: OAuthConfig.googleServerClientId,
  );

  void changeTab(int index) {
    if (index == 0) {
      isSignUp.value = false;
    } else {
      isSignUp.value = true;
    }
    update();
  }

  void showEmailLoginForm() {
    showEmailForm.value = true;
    update();
  }

  void hideEmailForm() {
    showEmailForm.value = false;
    update();
  }

  Future<void> signInBtnOperation() async {
    if (emailController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter your email',
      );
      return;
    }
    
    // Validate email format
    if (!emailController.text.contains('@') || !emailController.text.contains('.')) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter a valid email address',
      );
      return;
    }
    
    isLoading.value = true;

    // Request OTP for login
    final result = await authApiCalls.requestLoginOTP(
      email: emailController.text.trim(),
    );
    
    result.fold(
      (failure) {
        ToastDialogs.showErrorIconNotification(
          message: failure.message ?? 'Failed to send login code',
        );
      },
      (successMessage) {
        ToastDialogs.showSuccessNotification(
          message: successMessage,
        );
        
        // Show OTP verification modal for login
        _showLoginOTPVerificationModal();
      },
    );
    isLoading.value = false;
  }

  /// Extract username from email (part before @)
  String extractUsernameFromEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return '';
    }
    return email.split('@')[0];
  }

  Future<void> signUpBtnOperation() async {
    if (firstNameController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter first name',
      );
      return;
    }
    if (lastNameController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(message: 'Please enter last name');
      return;
    }
    if (emailController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter your email',
      );
      return;
    }
    if (!emailController.text.contains('@') &&
        !emailController.text.contains('.com')) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter a valid email',
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter your password',
      );
      return;
    }

    // Password validation
    String? passwordError = validatePassword(passwordController.text);
    if (passwordError != null) {
      ToastDialogs.showErrorIconNotification(message: passwordError);
      return;
    }

    isLoading.value = true;

    final result = await authApiCalls.signUp(
      UserModel(
        username: extractUsernameFromEmail(emailController.text),
        email: emailController.text,
        password: passwordController.text,
        passwordConfirm: passwordController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
      ),
    );
    result.fold(
      (failure) {
        ToastDialogs.showErrorIconNotification(
          message: failure.message ?? 'An error occurred',
        );
      },
      (user) async {
        // Save userId if present
        if (user.id != null) {
          final localStorage = await LocalStorageManager.getInstance();
          await localStorage.saveUserId(user.id!);
        }

        // Show OTP verification modal
        _showOTPVerificationModal();
      },
    );
    isLoading.value = false;
  }

  Future<void> forgetPassword() async {
    if (emailController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Please enter your email',
      );
      return;
    }
    isLoadingForgetPassword.value = true;

    final result = await authApiCalls.forgetPassword(emailController.text);
    result.fold(
      (failure) {
        ToastDialogs.showErrorIconNotification(
          message: failure.message ?? 'An error occurred',
        );
      },
      (message) {
        ToastDialogs.showSuccessNotification(
          message: 'Please check your email',
        );
        Navigator.of(Get.context!).pop();
      },
    );
    isLoadingForgetPassword.value = false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  @override
  void onInit() {
    super.onInit();
    // Add listeners to focus nodes to trigger UI updates
    emailFocusNode.addListener(() => update());
    passwordFocusNode.addListener(() => update());
    firstNameFocusNode.addListener(() => update());
    lastNameFocusNode.addListener(() => update());
    confirmPasswordFocusNode.addListener(() => update());
  }

  @override
  void onClose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  String? validatePassword(String password) {
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

  void _showOTPVerificationModal() {
    Get.dialog(
      OTPVerificationModal(
        email: emailController.text,
        title: '🎉 Welcome Aboard!',
        subtitle: 'Thank you for joining us! We\'ve sent a 5-digit verification code to your email address. Please enter it below to complete your registration.',
        onVerify: (otp) => _verifyRegistrationOTP(otp),
        onResend: () => _resendVerificationOTP(),
        onClose: () => Get.back(),
        isLoading: isLoadingResendEmail.value,
        hasError: _otpHasError.value,
        isSuccess: _otpIsSuccess.value,
        errorMessage: _otpErrorMessage.value,
      ),
      barrierDismissible: false,
    );
  }

  /// Verifies the OTP for registration
  Future<void> _verifyRegistrationOTP(String otp) async {
    try {
      // Reset states
      _otpHasError.value = false;
      _otpIsSuccess.value = false;
      _otpErrorMessage.value = '';

      // Call API to verify OTP
      final result = await authApiCalls.verifyEmail(
        email: emailController.text,
        otp: otp,
      );

      result.fold(
        (failure) {
          // Handle API error
          _otpHasError.value = true;
          _otpErrorMessage.value = failure.message ?? 'Invalid verification code. Please try again.';
        },
        (successMessage) {
          // Show success state
          _otpIsSuccess.value = true;
          
          // Show success message
          ToastDialogs.showSuccessNotification(
            message: 'Email verified successfully!',
          );
          
          // Close modal and navigate to login after a short delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back(); // Close modal
            changeTab(0); // Switch to login tab
            
            // Clear form fields
            firstNameController.clear();
            lastNameController.clear();
            emailController.clear();
            passwordController.clear();
          });
        },
      );
    } catch (e) {
      // Handle unexpected errors
      _otpHasError.value = true;
      _otpErrorMessage.value = 'An unexpected error occurred. Please try again.';
    }
  }

  /// Resends the verification OTP
  Future<void> _resendVerificationOTP() async {
    if (emailController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Email address not found',
      );
      return;
    }

    isLoadingResendEmail.value = true;

    final result = await authApiCalls.resendVerificationEmail(
      email: emailController.text,
    );
    result.fold(
      (failure) {
        ToastDialogs.showErrorIconNotification(
          message: failure.message ?? 'Failed to resend verification code',
        );
      },
      (message) {
        ToastDialogs.showSuccessNotification(
          message: 'Verification code sent successfully!',
        );
        
        // Reset OTP states
        _otpHasError.value = false;
        _otpIsSuccess.value = false;
        _otpErrorMessage.value = '';
      },
    );
    isLoadingResendEmail.value = false;
  }

  /// Shows OTP verification modal for login
  void _showLoginOTPVerificationModal() {
    Get.dialog(
      OTPVerificationModal(
        email: emailController.text,
        title: 'Verify Your Login',
        subtitle: 'We\'ve sent a 5-digit verification code to your email address. Please enter it below to sign in.',
        onVerify: (otp) => _verifyLoginOTP(otp),
        onResend: () => _resendLoginOTP(),
        onClose: () => Get.back(),
        isLoading: isLoadingResendEmail.value,
        hasError: _loginOtpHasError.value,
        isSuccess: _loginOtpIsSuccess.value,
        errorMessage: _loginOtpErrorMessage.value,
      ),
      barrierDismissible: false,
    );
  }

  /// Verifies the OTP for login
  Future<void> _verifyLoginOTP(String otp) async {
    try {
      // Reset states
      _loginOtpHasError.value = false;
      _loginOtpIsSuccess.value = false;
      _loginOtpErrorMessage.value = '';

      // Call API to verify OTP and login
      final result = await authApiCalls.loginWithOPT(
        email: emailController.text.trim(),
        otp: otp,
      );

      result.fold(
        (failure) {
          // Handle API error
          _loginOtpHasError.value = true;
          _loginOtpErrorMessage.value = failure.message ?? 'Invalid verification code. Please try again.';
        },
        (successMessage) {
          // Show success state
          _loginOtpIsSuccess.value = true;
          
          // Show success message
          ToastDialogs.showSuccessNotification(
            message: 'Login successful!',
          );
          
          // Close modal and navigate to main screen after a short delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back(); // Close modal
            Get.offNamedUntil(Routes.main, (route) => false);
            
            // Clear form fields
            emailController.clear();
          });
        },
      );
    } catch (e) {
      // Handle unexpected errors
      _loginOtpHasError.value = true;
      _loginOtpErrorMessage.value = 'An unexpected error occurred. Please try again.';
    }
  }

  /// Resends the login OTP
  Future<void> _resendLoginOTP() async {
    if (emailController.text.isEmpty) {
      ToastDialogs.showErrorIconNotification(
        message: 'Email address not found',
      );
      return;
    }

    isLoadingResendEmail.value = true;

    final result = await authApiCalls.requestLoginOTP(
      email: emailController.text.trim(),
    );
    result.fold(
      (failure) {
        ToastDialogs.showErrorIconNotification(
          message: failure.message ?? 'Failed to resend login code',
        );
      },
      (message) {
        ToastDialogs.showSuccessNotification(
          message: 'Login code sent successfully!',
        );
        
        // Reset OTP states
        _loginOtpHasError.value = false;
        _loginOtpIsSuccess.value = false;
        _loginOtpErrorMessage.value = '';
      },
    );
    isLoadingResendEmail.value = false;
  }

  Future<void> signInWithGoogle() async {
    try {
      // Set loading state
      isLoading.value = true;

      // Debug information
      if (kDebugMode) {
        print('=== Google Sign-In Debug Info ===');
        print('Package: com.nematiai.keytype');
        print(
            'SHA-1: 63:6A:16:A9:C5:96:38:B9:ED:61:A3:FC:12:C6:DE:23:81:B3:10:DE');
        print('Server Client ID: ${OAuthConfig.googleServerClientId}');
        print('================================');
      }

      // Sign out any existing sessions
      await _googleSignIn.signOut();

      // Attempt to sign in
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User cancelled the sign-in
        ToastDialogs.showErrorIconNotification(
          message: 'Google sign-in cancelled',
        );
        return;
      }

      // Get authentication details
      final GoogleSignInAuthentication auth = await account.authentication;

      if (auth.accessToken == null) {
        ToastDialogs.showErrorIconNotification(
          message: 'Failed to get Google access token',
        );
        return;
      }

      // Call API with Google access token
      await authApiCalls.callGoogleAuth(auth.accessToken!).fold(
        (failure) {
          ToastDialogs.showErrorIconNotification(
            message: failure.message ?? 'Google sign-in failed',
          );
          print('Google Sign-In API Error: ${failure.message}');
        },
        (loginResponseModel) async {
          await Utils.saveToken(
            loginResponseModel.refreshToken,
            loginResponseModel.accessToken,
          );

          // Navigate to main screen
          Get.offNamedUntil(Routes.main, (route) => false);
        },
      );
    } on PlatformException catch (error) {
      // Handle platform-specific errors
      String errorMessage = 'Google sign-in failed';

      switch (error.code) {
        case 'sign_in_failed':
          errorMessage =
              'Google sign-in not properly configured. Please check Firebase setup.';
          break;
        case 'network_error':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        case 'sign_in_canceled':
          errorMessage = 'Sign-in cancelled';
          break;
        default:
          errorMessage = 'Google sign-in failed: ${error.message}';
      }

      ToastDialogs.showErrorIconNotification(message: errorMessage);
      print('Google Sign-In Platform Error: ${error.code} - ${error.message}');
    } catch (error) {
      ToastDialogs.showErrorIconNotification(
        message: 'An unexpected error occurred during Google sign-in',
      );
      print('Google Sign-In Unexpected Error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithTwitter() async {
    // For now, show coming soon message
    ToastDialogs.showSuccessNotification(
      title: 'Coming Soon',
      message: 'Twitter login will be available soon!',
    );
  }
}

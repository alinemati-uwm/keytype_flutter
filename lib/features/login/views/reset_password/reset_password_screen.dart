import 'package:animate_do/animate_do.dart';
import 'reset_password_controller.dart';
import '../../../../ui_imports.dart';
import '../../../../components/animations/loading_animation.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller and set email
    controller = Get.put(ResetPasswordController());
    controller.setEmail(widget.email);
    controller.setotp(widget.otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Top section with title (scrollable)
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        'Create New Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Gap(12),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        'Your new password must be different from previously used passwords',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom sheet style container - stays fixed at bottom
      bottomSheet: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.62,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildUpdatePasswordForm(context),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdatePasswordForm(BuildContext context) {
    const primaryColor = Color(0xFF6B8E7F);

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryColor,
          selectionColor: primaryColor.withOpacity(0.3),
          selectionHandleColor: primaryColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header
          SlideInLeft(
            delay: Duration(milliseconds: 400),
            duration: Duration(milliseconds: 600),
            child: Text(
              'Reset Your Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          Gap(8),
          SlideInLeft(
            delay: Duration(milliseconds: 600),
            duration: Duration(milliseconds: 600),
            child: Text(
              'Create a new secure password',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
          Gap(32),

          // New Password field
          SlideInUp(
            delay: Duration(milliseconds: 1000),
            duration: Duration(milliseconds: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                Gap(8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: controller.newPasswordFocusNode.hasFocus
                          ? primaryColor
                          : Colors.grey[200]!,
                      width: controller.newPasswordFocusNode.hasFocus ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.lock_reset,
                          color: controller.newPasswordFocusNode.hasFocus
                              ? primaryColor
                              : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: GetBuilder<ResetPasswordController>(
                          builder: (ctrl) => TextField(
                            controller: ctrl.newPasswordController,
                            focusNode: ctrl.newPasswordFocusNode,
                            obscureText: !ctrl.isNewPasswordVisible.value,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter new password',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              suffixIcon: Obx(() => IconButton(
                                    icon: Icon(
                                      ctrl.isNewPasswordVisible.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: ctrl.newPasswordFocusNode.hasFocus
                                          ? primaryColor
                                          : Colors.grey[400],
                                      size: 20,
                                    ),
                                    onPressed: ctrl.toggleNewPasswordVisibility,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(24),

          // Confirm Password field
          SlideInUp(
            delay: Duration(milliseconds: 1200),
            duration: Duration(milliseconds: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confirm New Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                Gap(8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: controller.confirmPasswordFocusNode.hasFocus
                          ? primaryColor
                          : Colors.grey[200]!,
                      width:
                          controller.confirmPasswordFocusNode.hasFocus ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.verified_user_outlined,
                          color: controller.confirmPasswordFocusNode.hasFocus
                              ? primaryColor
                              : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: GetBuilder<ResetPasswordController>(
                          builder: (ctrl) => TextField(
                            controller: ctrl.confirmPasswordController,
                            focusNode: ctrl.confirmPasswordFocusNode,
                            obscureText: !ctrl.isConfirmPasswordVisible.value,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: primaryColor,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Confirm new password',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              suffixIcon: Obx(() => IconButton(
                                    icon: Icon(
                                      ctrl.isConfirmPasswordVisible.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color:
                                          ctrl.confirmPasswordFocusNode.hasFocus
                                              ? primaryColor
                                              : Colors.grey[400],
                                      size: 20,
                                    ),
                                    onPressed:
                                        ctrl.toggleConfirmPasswordVisibility,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(24),

          // Password requirements
          SlideInUp(
            delay: Duration(milliseconds: 1400),
            duration: Duration(milliseconds: 600),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: primaryColor,
                        size: 18,
                      ),
                      Gap(8),
                      Text(
                        'Password Requirements',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Gap(12),
                  _buildRequirement('At least 8 characters long'),
                  _buildRequirement('Contains uppercase and lowercase letters'),
                  _buildRequirement('Contains at least one number'),
                  _buildRequirement('Contains at least one special character'),
                ],
              ),
            ),
          ),
          Gap(32),

          // Update Password Button
          SlideInUp(
            delay: Duration(milliseconds: 1600),
            duration: Duration(milliseconds: 600),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.updatePassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? LoadingAnimation(
                            size: 24,
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.security,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  )),
            ),
          ),
          Gap(24),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF374151),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

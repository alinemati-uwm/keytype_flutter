import 'package:animate_do/animate_do.dart';
import 'package:keytype/features/login/login_controller.dart';
import 'package:keytype/features/login/views/forget_password/forget_password_screen.dart';
import '../../components/modals/coming_soon_modal.dart';
import '../../ui_imports.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (logic) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A), // Dark background
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (controller.showEmailForm.value) {
                  controller.hideEmailForm();
                } else {
                  Get.back();
                }
              },
            ),
          ),
          body: Column(
            children: [
              // Top section with title (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Go ahead and set up\nyour account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const Gap(8),
                        FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Sign in-up to enjoy the best writing experience',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
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
                maxHeight: MediaQuery.of(context).size.height * 0.7,
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
                child: Obx(
                  () => controller.showEmailForm.value
                      ? _buildEmailForm(context)
                      : _buildLoginButtons(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Welcome text
        Text(
          'Choose your preferred login method',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(32),

        // Google Login Button
        FadeInUp(
          delay: Duration(milliseconds: 100),
          child: _buildAuthMethodButton(
            icon: 'assets/icons/google.svg',
            title: 'Continue with Google',
            subtitle: 'Fast and secure',
            onTap: () {
              ComingSoonModal.show(
                context: context,
                featureName: 'Google Sign In',
                description: 'Quick and secure authentication with your Google account. We\'re working on integrating this feature!',
                svgIcon: 'assets/icons/google.svg',
                primaryColor: const Color.fromARGB(255, 204, 67, 52),
              );
            },
            color: Colors.white,
            borderColor: Colors.grey[300]!,
            textColor: Colors.black87,
          ),
        ),
        const Gap(16),

        // Twitter Login Button
        FadeInUp(
          delay: Duration(milliseconds: 200),
          child: _buildAuthMethodButton(
            icon: 'assets/icons/twitter.svg',
            title: 'Continue with Twitter',
            subtitle: 'Connect with friends',
            onTap: () {
              ComingSoonModal.show(
                context: context,
                featureName: 'Twitter Sign In',
                description: 'Connect with your Twitter account for seamless login. This feature is coming soon with enhanced security!',
                svgIcon: 'assets/icons/twitter.svg',
                primaryColor: const Color(0xFF1877F2),
              );
            },
            color: Color(0xFF1877F2),
            borderColor: Color(0xFF1877F2),
            textColor: Colors.white,
          ),
        ),
        const Gap(16),

        // Email Login Button
        FadeInUp(
          delay: Duration(milliseconds: 300),
          child: _buildAuthMethodButton(
            icon: null,
            title: 'Continue with Email',
            subtitle: 'Use your email address',
            onTap: () => controller.showEmailLoginForm(),
            color: Color(0xFF6B8E7F),
            borderColor: Color(0xFF6B8E7F),
            textColor: Colors.white,
            iconWidget: Icon(
              Icons.email_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const Gap(32),
      ],
    );
  }

  Widget _buildAuthMethodButton({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required Color borderColor,
    required Color textColor,
    String? icon,
    Widget? iconWidget,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: textColor == Colors.white
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: iconWidget ??
                    (icon != null
                        ? SvgPicture.asset(
                            icon,
                            width: 24,
                            height: 24,
                            colorFilter: textColor == Colors.white
                                ? ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  )
                                : null,
                          )
                        : Icon(Icons.email, color: textColor, size: 24)),
              ),
            ),
            const Gap(16),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: textColor.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab buttons for Login/Register
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(0),
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !controller.isSignUp.value
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: !controller.isSignUp.value
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: !controller.isSignUp.value
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(1),
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.isSignUp.value
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: controller.isSignUp.value
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: controller.isSignUp.value
                                ? Colors.black
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(24),

        // Form fields
        Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: controller.isSignUp.value
                ? _buildRegisterForm(context)
                : _buildLoginForm(context),
          ),
        ),
        const Gap(8),

        // Remember me and Forgot Password (only for login)
        Obx(
          () => !controller.isSignUp.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Obx(
                            () => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {
                                controller.toggleRememberMe();
                              },
                              activeColor: const Color(0xFF6B8E7F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(
                          () => ForgetPasswordScreen(),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),
        const Gap(24),

        // Login/Register Button
        _buildMainButton(),
        const Gap(20),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
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
        key: ValueKey('login'),
        children: [
          // Email field
          GetBuilder<LoginController>(
            builder: (controller) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.emailFocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[200]!,
                  width: controller.emailFocusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.email_outlined,
                      color: controller.emailFocusNode.hasFocus
                          ? primaryColor
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.emailController,
                      focusNode: controller.emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          // Info text about OTP login
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6B8E7F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF6B8E7F).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: const Color(0xFF6B8E7F),
                  size: 20,
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'We\'ll send a verification code to your email for secure login',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF6B8E7F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
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
        key: ValueKey('register'),
        children: [
          // First and Last Name Row
          Row(
            children: [
              // First Name field
              Expanded(
                child: GetBuilder<LoginController>(
                  builder: (controller) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.firstNameFocusNode.hasFocus
                            ? primaryColor
                            : Colors.grey[200]!,
                        width: controller.firstNameFocusNode.hasFocus ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            Icons.person_outline,
                            color: controller.firstNameFocusNode.hasFocus
                                ? primaryColor
                                : Colors.grey[400],
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.firstNameController,
                            focusNode: controller.firstNameFocusNode,
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(12),
              // Last Name field
              Expanded(
                child: GetBuilder<LoginController>(
                  builder: (controller) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.lastNameFocusNode.hasFocus
                            ? primaryColor
                            : Colors.grey[200]!,
                        width: controller.lastNameFocusNode.hasFocus ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Icon(
                            Icons.person_outline,
                            color: controller.lastNameFocusNode.hasFocus
                                ? primaryColor
                                : Colors.grey[400],
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.lastNameController,
                            focusNode: controller.lastNameFocusNode,
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
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
          const Gap(16),
          // Email field
          GetBuilder<LoginController>(
            builder: (controller) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.emailFocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[200]!,
                  width: controller.emailFocusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.email_outlined,
                      color: controller.emailFocusNode.hasFocus
                          ? primaryColor
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller.emailController,
                      focusNode: controller.emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          // Password field
          GetBuilder<LoginController>(
            builder: (controller) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller.passwordFocusNode.hasFocus
                      ? primaryColor
                      : Colors.grey[200]!,
                  width: controller.passwordFocusNode.hasFocus ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.lock_outline,
                      color: controller.passwordFocusNode.hasFocus
                          ? primaryColor
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        focusNode: controller.passwordFocusNode,
                        obscureText: !controller.isPasswordVisible.value,
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: controller.passwordFocusNode.hasFocus
                                  ? primaryColor
                                  : Colors.grey[400],
                              size: 20,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          // Confirm Password field
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (controller.isLoading.value) return;
            if (controller.isSignUp.value) {
              controller.signUpBtnOperation();
            } else {
              controller.signInBtnOperation();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(
              0xFF6B8E7F,
            ), // Green color from screenshot
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  controller.isSignUp.value ? 'Register' : 'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

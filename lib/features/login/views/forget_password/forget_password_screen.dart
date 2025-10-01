import 'package:animate_do/animate_do.dart';
import 'forget_password_controller.dart';
import '../../../../ui_imports.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the ForgetPasswordController
    final controller = Get.put(ForgetPasswordController());

    return _buildScreen(context, controller);
  }

  Widget _buildScreen(
      BuildContext context, ForgetPasswordController controller) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B8E7F),
              Color(0xFF5A7C6F),
              Color(0xFF4A6B5F),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      SizedBox(height: 40),

                      // Animated illustration
                      _buildAnimatedIllustration(),

                      SizedBox(height: 50),

                      // Main card with form
                      _buildMainCard(context),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          FadeInLeft(
            duration: Duration(milliseconds: 600),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FadeInDown(
              delay: Duration(milliseconds: 200),
              duration: Duration(milliseconds: 600),
              child: Center(
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 44), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildAnimatedIllustration() {
    return FadeInDown(
      delay: Duration(milliseconds: 400),
      duration: Duration(milliseconds: 800),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated rings
            ...List.generate(3, (index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 2000 + (index * 500)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.3 + (value * 0.7),
                    child: Container(
                      width: 160 - (index * 20),
                      height: 160 - (index * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3 - (index * 0.1)),
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
                onEnd: () {
                  // Restart animation
                },
              );
            }),

            // Central icon
            SlideInUp(
              delay: Duration(milliseconds: 800),
              duration: Duration(milliseconds: 600),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lock_reset,
                  color: Color(0xFF6B8E7F),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 600),
      duration: Duration(milliseconds: 800),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header text
            _buildHeaderSection(),

            SizedBox(height: 32),

            // Email input
            _buildEmailInput(),

            SizedBox(height: 32),

            // Submit button
            _buildSubmitButton(),

            SizedBox(height: 24),

            // Help text
            _buildHelpText(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideInLeft(
          delay: Duration(milliseconds: 800),
          duration: Duration(milliseconds: 600),
          child: Text(
            'Forgot your password?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
              height: 1.2,
            ),
          ),
        ),
        SizedBox(height: 12),
        SlideInLeft(
          delay: Duration(milliseconds: 1000),
          duration: Duration(milliseconds: 600),
          child: Text(
            'Don\'t worry! It happens to the best of us. Enter your email address below and we\'ll send you a verification code to reset your password.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput() {
    return SlideInUp(
      delay: Duration(milliseconds: 1200),
      duration: Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xFFE2E8F0),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.email_outlined,
                    color: Color(0xFF6B8E7F),
                    size: 22,
                  ),
                ),
                Expanded(
                  child: GetBuilder<ForgetPasswordController>(
                    builder: (ctrl) => TextField(
                      controller: ctrl.emailController,
                      focusNode: ctrl.emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: TextStyle(
                          color: Color(0xFFA0AEC0),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 0,
                        ),
                      ),
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

  Widget _buildSubmitButton() {
    final controller = Get.find<ForgetPasswordController>();
    return SlideInUp(
      delay: Duration(milliseconds: 1400),
      duration: Duration(milliseconds: 600),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF6B8E7F),
              Color(0xFF5A7C6F),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6B8E7F).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await controller.requestPasswordReset();
            },
            child: Container(
              alignment: Alignment.center,
              child: Obx(() => controller.isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Send Reset Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHelpText() {
    return SlideInUp(
      delay: Duration(milliseconds: 1600),
      duration: Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFF6B8E7F).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF6B8E7F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info_outline,
                color: Color(0xFF6B8E7F),
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need help?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF166534),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Check your spam folder or contact support if you don\'t receive the code within 5 minutes.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF166534),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

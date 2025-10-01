import 'package:animate_do/animate_do.dart';
import 'confirm_reset_password_controller.dart';
import '../../../../ui_imports.dart';
import '../../../../components/otp/otp_input_widget.dart';

class ConfirmResetPasswordScreen extends StatefulWidget {
  const ConfirmResetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<ConfirmResetPasswordScreen> createState() =>
      _ConfirmResetPasswordScreenState();
}

class _ConfirmResetPasswordScreenState extends State<ConfirmResetPasswordScreen> {
  late ConfirmResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller and set email
    controller = Get.put(ConfirmResetPasswordController());
    controller.setEmail(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B8E7F),
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
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
                  'Verify Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
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
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated pulse rings
            ...List.generate(3, (index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 2000 + (index * 400)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.4 + (value * 0.6),
                    child: Container(
                      width: 140 - (index * 20),
                      height: 140 - (index * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4 - (index * 0.1)),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
                onEnd: () {
                  // Restart animation by triggering rebuild
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
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 25,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.security,
                  color: Color(0xFF6B8E7F),
                  size: 40,
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
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 40,
              offset: Offset(0, 20),
            ),
          ],
        ),
        padding: EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header text
            _buildHeaderSection(),

            SizedBox(height: 40),

            // Code input boxes
            _buildCodeInput(),

            SizedBox(height: 32),

            // Info text
            _buildInfoText(),

            SizedBox(height: 24),

            // Resend button
            _buildResendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        SlideInDown(
          delay: Duration(milliseconds: 800),
          duration: Duration(milliseconds: 600),
          child: Text(
            'Enter Verification Code',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 16),
        SlideInUp(
          delay: Duration(milliseconds: 1000),
          duration: Duration(milliseconds: 600),
          child: Text(
            'We\'ve sent a 5-digit verification code to ${widget.email}. Please enter it below to continue.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
              height: 1.6,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInput() {
    return SlideInUp(
      delay: Duration(milliseconds: 1200),
      duration: Duration(milliseconds: 600),
      child: Obx(() => OTPInputWidget(
            length: 5,
            onCompleted: (otp) => controller.verifyOTP(otp),
            onChanged: (otp) => controller.onOTPChanged(otp),
            hasError: controller.hasError.value,
            isSuccess: controller.isSuccess.value,
            errorMessage: controller.currentErrorMessage,
            onResend: () => controller.resendOTP(),
            isLoading: controller.isResendLoading.value,
          )),
    );
  }

  Widget _buildInfoText() {
    return SlideInUp(
      delay: Duration(milliseconds: 1800),
      duration: Duration(milliseconds: 600),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFF0F9FF),
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
                Icons.timer_outlined,
                color: Color(0xFF6B8E7F),
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'The code will expire in 10 minutes. Make sure to check your spam folder.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E40AF),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendButton() {
    // This is now handled by the OTP input widget
    return SizedBox.shrink();
  }
}

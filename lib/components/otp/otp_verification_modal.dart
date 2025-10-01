import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'otp_input_widget.dart';

class OTPVerificationModal extends StatefulWidget {
  final String email;
  final String title;
  final String subtitle;
  final Function(String) onVerify;
  final VoidCallback? onResend;
  final VoidCallback? onClose;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;
  final bool isSuccess;

  const OTPVerificationModal({
    super.key,
    required this.email,
    this.title = 'Verify Your Email',
    this.subtitle = 'We\'ve sent a 5-digit verification code to your email address. Please enter it below to continue.',
    required this.onVerify,
    this.onResend,
    this.onClose,
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
    this.isSuccess = false,
  });

  @override
  State<OTPVerificationModal> createState() => _OTPVerificationModalState();
}

class _OTPVerificationModalState extends State<OTPVerificationModal>
    with TickerProviderStateMixin {
  final GlobalKey _otpKey = GlobalKey();
  late AnimationController _modalController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _modalController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modalController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modalController,
      curve: Curves.easeOut,
    ));

    _modalController.forward();
  }

  @override
  void dispose() {
    _modalController.dispose();
    super.dispose();
  }

  void _closeModal() {
    _modalController.reverse().then((_) {
      if (widget.onClose != null) {
        widget.onClose!();
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button dismissal
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: AnimatedBuilder(
          animation: _modalController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Center(
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with close button
                          _buildHeader(),
                          
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                // Animated illustration
                                _buildIllustration(),
                                
                                const SizedBox(height: 32),
                                
                                // Title and subtitle
                                _buildTitleSection(),
                                
                                const SizedBox(height: 32),
                                
                                // OTP Input
                                OTPInputWidget(
                                  key: _otpKey,
                                  onCompleted: widget.onVerify,
                                  hasError: widget.hasError,
                                  isSuccess: widget.isSuccess,
                                  errorMessage: widget.errorMessage,
                                  onResend: widget.onResend,
                                  isLoading: widget.isLoading,
                                ),
                                
                                // const SizedBox(height: 24),
                                
                                // Info text
                                _buildInfoText(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FadeInRight(
            duration: const Duration(milliseconds: 600),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _closeModal,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return FadeInDown(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 800),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF6B8E7F).withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF6B8E7F).withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated rings
            ...List.generate(2, (index) {
              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 2000 + (index * 500)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.4 + (value * 0.6),
                    child: Container(
                      width: 100 - (index * 20),
                      height: 100 - (index * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF6B8E7F).withOpacity(0.3 - (index * 0.1)),
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
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFF6B8E7F),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        SlideInDown(
          delay: const Duration(milliseconds: 600),
          duration: const Duration(milliseconds: 600),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3748),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        SlideInUp(
          delay: const Duration(milliseconds: 800),
          duration: const Duration(milliseconds: 600),
          child: Text(
            widget.subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
              height: 1.5,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        SlideInUp(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6B8E7F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.email,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B8E7F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText() {
    return SlideInUp(
      delay: const Duration(milliseconds: 1200),
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF6B8E7F).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF6B8E7F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.timer_outlined,
                color: Color(0xFF6B8E7F),
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'The code will expire in 10 minutes. Check your spam folder if you don\'t see it.',
                style: TextStyle(
                  fontSize: 12,
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
}
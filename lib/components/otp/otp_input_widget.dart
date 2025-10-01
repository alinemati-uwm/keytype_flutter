import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';

class OTPInputWidget extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final bool hasError;
  final bool isSuccess;
  final VoidCallback? onResend;
  final bool isLoading;
  final String? errorMessage;

  const OTPInputWidget({
    super.key,
    this.length = 5,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
    this.isSuccess = false,
    this.onResend,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<OTPInputWidget> createState() => _OTPInputWidgetState();
}

class _OTPInputWidgetState extends State<OTPInputWidget>
    with TickerProviderStateMixin {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late AnimationController _shakeController;
  late AnimationController _successController;
  late Animation<Offset> _shakeAnimation;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _successController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _successAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _shakeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(OTPInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.hasError && !oldWidget.hasError) {
      _triggerShakeAnimation();
    }
    
    if (widget.isSuccess && !oldWidget.isSuccess) {
      _triggerSuccessAnimation();
    }
  }

  void _triggerShakeAnimation() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  void _triggerSuccessAnimation() {
    _successController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _successController.reverse();
      });
    });
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      // Move to previous field
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Get current OTP value
    String currentOTP = _controllers.map((c) => c.text).join();
    
    // Call onChanged callback
    if (widget.onChanged != null) {
      widget.onChanged!(currentOTP);
    }

    // Check if OTP is complete
    if (currentOTP.length == widget.length) {
      widget.onCompleted(currentOTP);
    }
  }

  Color _getBorderColor(int index) {
    if (widget.hasError) {
      return Colors.red;
    }
    
    if (widget.isSuccess) {
      return Colors.green;
    }

    if (_controllers[index].text.isNotEmpty) {
      return const Color(0xFF6B8E7F);
    }

    if (_focusNodes[index].hasFocus) {
      return const Color(0xFF6B8E7F);
    }

    return const Color(0xFFE2E8F0);
  }

  void clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: _shakeAnimation.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.length, (index) {
                  return AnimatedBuilder(
                    animation: _successAnimation,
                    builder: (context, child) {
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        duration: const Duration(milliseconds: 600),
                        child: Transform.scale(
                          scale: widget.isSuccess ? _successAnimation.value : 1.0,
                          child: Container(
                            width: 45,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _getBorderColor(index),
                                width: 2.5,
                              ),
                              boxShadow: [
                                if (_controllers[index].text.isNotEmpty)
                                  BoxShadow(
                                    color: _getBorderColor(index).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3748),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (value) => _onChanged(value, index),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            );
          },
        ),
        if (widget.errorMessage != null) ...[
          const SizedBox(height: 16),
          FadeIn(
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        if (widget.onResend != null) ...[
          // const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: TextButton(
              onPressed: widget.isLoading ? null : widget.onResend,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFF6B8E7F),
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh,
                          color: Color(0xFF6B8E7F),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Didn\'t receive the code? Resend',
                          style: TextStyle(
                            color: Color(0xFF6B8E7F),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ],
    );
  }
}
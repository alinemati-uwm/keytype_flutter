import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CustomModal extends StatefulWidget {
  final Widget child;
  final bool isDismissible;
  final VoidCallback? onClose;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool showCloseButton;
  final Duration animationDuration;

  const CustomModal({
    super.key,
    required this.child,
    this.isDismissible = true,
    this.onClose,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.showCloseButton = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<CustomModal> createState() => _CustomModalState();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    VoidCallback? onClose,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool showCloseButton = true,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => CustomModal(
        isDismissible: isDismissible,
        onClose: onClose,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        padding: padding,
        margin: margin,
        showCloseButton: showCloseButton,
        animationDuration: animationDuration,
        child: child,
      ),
    );
  }
}

class _CustomModalState extends State<CustomModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeModal() {
    _controller.reverse().then((_) {
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
      onWillPop: () async => widget.isDismissible,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 20),
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.white,
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showCloseButton) _buildCloseButton(),
                      Flexible(
                        child: Padding(
                          padding: widget.padding ?? const EdgeInsets.all(24),
                          child: widget.child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
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
}

class BottomSheetModal extends StatefulWidget {
  final Widget child;
  final bool isDismissible;
  final VoidCallback? onClose;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final bool showCloseButton;
  final bool enableDrag;
  final Duration animationDuration;

  const BottomSheetModal({
    super.key,
    required this.child,
    this.isDismissible = true,
    this.onClose,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.showCloseButton = true,
    this.enableDrag = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<BottomSheetModal> createState() => _BottomSheetModalState();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    VoidCallback? onClose,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    bool showCloseButton = true,
    bool enableDrag = true,
    Duration animationDuration = const Duration(milliseconds: 300),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetModal(
        isDismissible: isDismissible,
        onClose: onClose,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        padding: padding,
        showCloseButton: showCloseButton,
        enableDrag: enableDrag,
        animationDuration: animationDuration,
        child: child,
      ),
    );
  }
}

class _BottomSheetModalState extends State<BottomSheetModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closeModal() {
    _controller.reverse().then((_) {
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
      onWillPop: () async => widget.isDismissible,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  borderRadius: widget.borderRadius ??
                      const BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.enableDrag) _buildDragHandle(),
                    if (widget.showCloseButton) _buildCloseButton(),
                    Flexible(
                      child: Padding(
                        padding: widget.padding ?? const EdgeInsets.all(24),
                        child: widget.child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
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
        ],
      ),
    );
  }
}
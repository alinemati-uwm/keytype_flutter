import '../ui_imports.dart';
import 'custom_loading.dart';
import 'custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.color,
      this.height,
      this.width,
      this.text,
      this.isActive = true,
      this.isLoading = false,
      this.withShadow = true,
      this.child,
      this.styleText,
      required this.onTap});

  final Color? color;
  final double? height;
  final double? width;
  final Widget? child;
  final TextStyle? styleText;
  final String? text;
  final bool isActive;
  final bool isLoading;
  final bool withShadow;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      radius: 16,
      child: Container(
        height: height ?? 42,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: color ?? AppColors.primaryDefault,
            borderRadius: radius12,
            boxShadow: withShadow ? [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                offset: const Offset(0, 1), // changes position of shadow
              )
            ] : []),
        child: isLoading
            ? CustomLoading()
            : child ??
                CustomTextWidget(
                  text ?? 'Login',
                  style: styleText ??
                      AppTextTheme.textStyleDMSanse16W700(color: Colors.white),
                  maxLines: 1,
                ),
      ),
    );
  }
}

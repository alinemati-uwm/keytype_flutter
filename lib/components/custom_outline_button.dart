
import 'package:keytype/components/custom_loading.dart';

import '../ui_imports.dart';

class CustomOutlineButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPress;
  final ButtonStyle? style;
  final Widget? icon;
  final TextStyle? textStyle;
  final bool? isLoading;

  const CustomOutlineButton({
    super.key,
    required this.buttonText,
    required this.onPress,
    this.style,
    this.icon,
    this.textStyle,
    this.isLoading,
  });

  @override
  Widget build(final BuildContext context) => SizedBox(
        height: 48,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPress,
          style: style ??
              OutlinedButton.styleFrom(
                textStyle: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkA,
                    fontWeight: FontWeight.w400),
                foregroundColor: AppColors.darkA,
                side:
                    BorderSide(color: AppColors.darkA),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
          child: isLoading == true
              ? const SizedBox(
                  height: 25, width: 25, child: CustomLoading())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) icon!,
                    const Gap(8),
                    Text(
                      buttonText,
                      style: textStyle,
                    ),
                  ],
                ),
        ),
      );
}

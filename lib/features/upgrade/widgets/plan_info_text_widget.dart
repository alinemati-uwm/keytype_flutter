import 'package:keytype/core/helper/base_brain.dart';

import '../../../ui_imports.dart';

class PlanInfoTextWidget extends StatelessWidget {
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? height;
  final double? width;

  const PlanInfoTextWidget(
      {super.key, this.fontWeight, this.fontSize, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 28, // Fixed height
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: (_hasPlan || isExpire)
            ? AppColors.successLight
            : AppColors.errorBg, // Background color
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            (_hasPlan || isExpire)
                ? 'assets/icons/ic_tick_circle.svg'
                : 'assets/icons/ic_close_outline.svg',
            height: 14, // Icon height
            width: 14, // Icon width
            colorFilter: ColorFilter.mode(
              // Color filter for icon
              (_hasPlan || isExpire)
                  ? AppColors.successDark
                  : AppColors.errorDark,
              BlendMode.srcIn,
            ),
          ),
          const Gap(4),
          Text(
            isExpire
                ? 'free'
                : _hasPlan
                    ? '$typePlan Plan'
                    : 'No Plan',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: (_hasPlan || isExpire)
                    ? AppColors.successDark
                    : AppColors.errorDark,
                fontWeight: fontWeight ?? FontWeight.w700,
                fontSize: fontSize),
          )
        ],
      ),
    );
  }

  bool get _hasPlan {
    final data= BaseBrain.userModel.value;

    return (data.subscription?.active == null ||
        data.subscription?.active == false)
        ? false
        : true;
  }

  String get typePlan {
    final data= BaseBrain.userModel.value;

    final plan = data.plan;
    return plan?.title ?? 'free';
  }

  bool get isExpire {
    final data= BaseBrain.userModel.value;

    final plan = data.subscription?.status;

    return plan == 'expired';
  }
}

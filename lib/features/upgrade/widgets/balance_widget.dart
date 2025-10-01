

import 'package:keytype/core/helper/base_brain.dart';

import '../../../ui_imports.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final subscription = BaseBrain.userModel.value.subscription;
    num credit = 0;

    if (subscription != null) {
      credit = subscription.totalCredit ?? 0;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      alignment: Alignment.center,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.grey,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/dollar.svg',
            colorFilter: ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 5.5), // Use SizedBox for spacing
          Text(
            formatNumber(credit.toDouble()),
            style: AppTextTheme.textStyleDMSanse16W700(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  String formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1).replaceAll(
          RegExp(r'\.0$'), '')} M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1).replaceAll(
          RegExp(r'\.0$'), '')} K';
    } else {
      return number.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
    }
  }
}

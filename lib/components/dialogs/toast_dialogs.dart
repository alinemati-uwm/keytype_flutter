import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_color.dart';
import '../custom_text_widget.dart';

abstract class ToastDialogs {
  static void showSuccessNotification({
    String title = 'Success',
    String message = 'Your work has been completed successfully',
  }) {
    BotToast.showCustomNotification(
      duration: const Duration(seconds: 5),
      toastBuilder: (onCancel) {
        return Container(
          constraints: const BoxConstraints(maxHeight: 65),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: AppColors.dark,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 6), // changes position of shadow
                )
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 65,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(12)),
                  color: AppColors.successDefault,
                ),
              ),
              const Gap(16),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.successDefault,
                  ),
                  height: 24,
                  width: 24,
                  padding: const EdgeInsets.all(3),
                  child: const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      title,
                      // style: AppTextTheme.textStyle16W700(
                      //     color: navigatorKey.currentState?.context != null
                      //         ? Theme.of(navigatorKey.currentState!.context)
                      //             .appColors
                      //             .textDark
                      //         : AppColors.textDark),
                    ),
                    CustomTextWidget(
                      message.isEmpty
                          ? 'Your work has been completed successfully'
                          : message,
                      maxLines: 2,
                      // style: AppTextTheme.textStyleDMSanse12W500(
                      //     color: navigatorKey.currentState?.context != null
                      //         ? Theme.of(navigatorKey.currentState!.context)
                      //             .appColors
                      //             .textDefault
                      //         : AppColors.textDefault),
                    ),
                  ],
                ),
              ),
              IconButton(
                  visualDensity:
                      const VisualDensity(horizontal: -3, vertical: -3),
                  onPressed: () {
                    onCancel();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                  ))
            ],
          ),
        );
      },
    );
  }

  static void showErrorIconNotification({
    String title = 'Error',
    String message = 'Your work encountered an error',
  }) {
    BotToast.showCustomNotification(
      duration: const Duration(seconds: 5),
      toastBuilder: (onCancel) {
        return Container(
          constraints: const BoxConstraints(maxHeight: 100),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: AppColors.dark,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 6), // changes position of shadow
                )
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: 65,
              //   width: 10,
              //   decoration: BoxDecoration(
              //     borderRadius:
              //         const BorderRadius.horizontal(left: Radius.circular(12)),
              //     color: AppColors.errorDark2,
              //   ),
              // ),
              const Gap(16),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.errorDark2,
                  ),
                  height: 24,
                  width: 24,
                  padding: const EdgeInsets.all(3),
                  child: const Icon(
                    Icons.close_sharp,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      title,
                      // style: AppTextTheme.textStyleDMSanse16W700(
                      //     color: navigatorKey.currentState?.context != null
                      //         ? Theme.of(navigatorKey.currentState!.context)
                      //             .appColors
                      //             .textDark
                      //         : AppColors.textDark),
                    ),
                    CustomTextWidget(
                      message.isEmpty
                          ? 'Your work encountered an error'
                          : message,
                      maxLines: 2,
                      // style: AppTextTheme.textStyleDMSanse12W500(
                      //     color: navigatorKey.currentState?.context != null
                      //         ? Theme.of(navigatorKey.currentState!.context)
                      //             .appColors
                      //             .textDefault
                      //         : AppColors.textDefault),
                    ),
                  ],
                ),
              ),
              IconButton(
                  visualDensity:
                      const VisualDensity(horizontal: -3, vertical: -3),
                  onPressed: () {
                    onCancel();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 18,
                  ))
            ],
          ),
        );
      },
    );
  }
}

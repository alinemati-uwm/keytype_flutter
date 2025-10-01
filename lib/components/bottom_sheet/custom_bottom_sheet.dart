import 'package:flutter/material.dart';
import 'package:keytype/core/theme/app_color.dart';

class CustomBottomSheet {
  static Future<dynamic> show(
      {required BuildContext context,
      required Widget Function(ScrollController scrollController) child}) {
    return showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: AppColors.dark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      enableDrag: false,
      showDragHandle: true,
      builder: (final BuildContext context) => DraggableScrollableSheet(
        expand: false,
        // controller: controller,
        minChildSize: 0.2,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return child(scrollController);
        },
      ),
    );
  }
}

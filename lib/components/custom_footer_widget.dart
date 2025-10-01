import 'package:flutter/material.dart';
import 'package:keytype/components/custom_loading.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomFooterWidget extends StatelessWidget {
  const CustomFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (context, mode) {
        Widget body;
        if (mode == LoadStatus.loading) {
          body = const CustomLoading();
        } else {
          body = const SizedBox();
        }
        return body;
      },
    );
  }
}

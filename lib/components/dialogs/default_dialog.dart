
import '../../ui_imports.dart';

class DefaultDialog extends StatelessWidget {
  final Widget widget;

  const DefaultDialog({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.dark,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      insetPadding: const EdgeInsets.only(left: 17, right: 17),
      child: widget,
    );
  }
}

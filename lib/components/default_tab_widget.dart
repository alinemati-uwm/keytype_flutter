import '../ui_imports.dart';

class DefaultTabWidget extends StatelessWidget {
  const DefaultTabWidget(
      {super.key,
      required this.tabLabel,
      this.controller,
      this.onTap,
      this.marginHorizontal});

  final List<String> tabLabel;
  final TabController? controller;
  final double? marginHorizontal;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: marginHorizontal ?? 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(300),
        borderRadius: BorderRadius.circular(
          12.0,
        ),
      ),
      child: TabBar(
        onTap: onTap,
        controller: controller,
        labelColor: Colors.white,
        dividerHeight: 0,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.grey,
            ),
        indicatorPadding: const EdgeInsets.symmetric(vertical: 5),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppTextTheme.textStyleDMSanse14W400(),
        tabs: tabLabel
            .map(
              (e) => Tab(
                  icon: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        e,
                        style: AppTextTheme.textStyleDMSanse14W500(),
                      ))),
            )
            .toList(),

      ),
    );
  }
}

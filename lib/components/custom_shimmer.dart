import 'package:shimmer/shimmer.dart';

import '../ui_imports.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer(
      {super.key,
      this.height,
      this.width,
      this.margin,
      this.enable,
      this.baseColor,
      this.highlightColor,
      this.radius});

  final double? height;
  final double? width;
  final double? radius;
  final EdgeInsets? margin;
  final bool? enable;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: enable ?? true,
      baseColor: baseColor ??
          AppColors.darkDefault,
      highlightColor: highlightColor ??
          AppColors.dark,
      child: Container(
        width: width ?? 80,
        height: height ?? 35,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(radius ?? 12)),
        margin: margin,
      ),
    );
  }
}

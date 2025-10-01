
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../ui_imports.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, this.color,
  this.size});

  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDualRing(
        size: size ?? 30,
        lineWidth: 4,
        color: color ?? AppColors.white,
          )
    );
  }
}

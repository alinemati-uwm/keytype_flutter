import 'package:auto_size_text/auto_size_text.dart';
import '../ui_imports.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget(
    this.text, {
    super.key,
    this.maxLines = 1,
    this.minFontSize = 10,
    this.style,
    this.textAlign,
  });

  final String text;
  final int maxLines;
  final double minFontSize;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: minFontSize,
      overflow: TextOverflow.ellipsis,
      style: style ?? AppTextTheme.textStyleDMSanse14W500(),
    );
  }
}

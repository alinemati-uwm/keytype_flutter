import '../ui_imports.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({super.key, required this.url, this.color, this.size,
  this.boxFit});

  final String url;
  final Color? color;
  final double? size;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    if(isSvg(url)) {
      return SvgPicture.asset(
        url,
        colorFilter:
        color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        height: size ?? 24,
        width: size ?? 24,
        fit: boxFit ?? BoxFit.contain,
      );
    }
    return Image.asset(url,
      width: size ?? 30,
      height: size ?? 30,
      color: color,
      fit: boxFit ?? BoxFit.contain,
    );
  }

  bool isSvg(String url) {
    return url.toLowerCase().endsWith('.svg');
  }

}

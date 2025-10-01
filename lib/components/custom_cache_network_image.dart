
import 'package:cached_network_image/cached_network_image.dart';

import '../ui_imports.dart';
import 'custom_loading.dart';

class CustomCacheNetworkImage extends StatelessWidget {
  const CustomCacheNetworkImage(
      {super.key,
        required this.url,
        this.radius = 12,
        this.errorWidgetColor,
        this.boxFit = BoxFit.cover});

  final String url;
  final double radius;
  final BoxFit boxFit;
  final Color? errorWidgetColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: boxFit,
            ),
          ),
        ),
        errorWidget: (context, url, error) =>  Center(
          child: Icon(Icons.image_not_supported_outlined,
          color: errorWidgetColor),
        ),
        progressIndicatorBuilder: (context, url, progress) => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 18, width: 18, child: CustomLoading()),
          ],
        ),
        fit: boxFit,
      ),
    );
  }
}

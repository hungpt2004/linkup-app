import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

// ignore: must_be_immutable
class MyImageWidget extends StatelessWidget {
  const MyImageWidget({
    super.key,
    required this.imageUrl,
    this.imageHeight,
    this.imageWidth,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? imageWidth; // Nên là final để tốt hơn cho StatelessWidget
  final double? imageHeight; // Nên là final để tốt hơn cho StatelessWidget
  final BoxFit fit; // <-- Đã thêm

  bool get isAsset => !imageUrl.contains('/') && !imageUrl.contains('http');
  bool get isNetwork => imageUrl.startsWith('http');
  bool get isFile => imageUrl.startsWith('/') || imageUrl.contains('cache/');

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    double? finalWidth = imageWidth;
    double? finalHeight = imageHeight;

    if (imageWidth != null && imageWidth != double.infinity) {
      finalWidth = ResponsiveSizeApp(context).widthPercent(imageWidth!);
    }
    if (imageHeight != null && imageHeight != double.infinity) {
      finalHeight = ResponsiveSizeApp(context).heightPercent(imageHeight!);
    }

    if (isNetwork) {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        fadeInCurve: Curves.easeIn,
        fadeInDuration: const Duration(milliseconds: 100),
        placeholder:
            (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            (context, url, error) => Center(
              child: PaddingLayout.all(
                value: 10,
                child: Image(
                  image: AssetImage(ImagePath.imageError),
                  fit: BoxFit.cover,
                  width: finalWidth,
                  height: finalHeight,
                ),
              ),
            ),
        fit: fit,
        width: finalWidth,
        height: finalHeight,
      );
    } else if (isFile) {
      imageWidget = Image.file(
        File(imageUrl),
        fit: fit,
        width: finalWidth,
        height: finalHeight,
        errorBuilder:
            (context, error, stackTrace) => Center(
              child: Image(
                image: AssetImage(ImagePath.imageError),
                fit: BoxFit.cover,
                width: finalWidth,
                height: finalHeight,
              ),
            ),
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        fit: fit,
        width: finalWidth,
        height: finalHeight,
      );
    }

    return imageWidget;
  }
}

import 'package:flutter/material.dart';

class ContainerLayout extends StatelessWidget {
  final Widget? child;
  final double? borderRadius;
  final String? backgroundImage;
  final String? centerImage;
  final Color? color;
  final double? width;
  final double? height;

  const ContainerLayout._({
    this.child,
    this.borderRadius,
    this.backgroundImage,
    this.centerImage,
    this.color,
    this.height,
    this.width,
    super.key,
  });

  /// Factory: chỉ màu nền và border radius
  factory ContainerLayout.radius({
    required double width,
    required double height,
    required double borderRadius,
    Color? color,
    Widget? child,
    Key? key,
  }) {
    return ContainerLayout._(
      borderRadius: borderRadius,
      color: color,
      width: width,
      height: height,
      key: key,
      child: child,
    );
  }

  /// Factory: background image và border radius
  factory ContainerLayout.backgroundImage({
    required String imagePath,
    double borderRadius = 0,
    Widget? child,
    Key? key,
  }) {
    return ContainerLayout._(
      backgroundImage: imagePath,
      borderRadius: borderRadius,
      key: key,
      child: child,
    );
  }

  /// Factory: background image, border radius, và image ở giữa
  factory ContainerLayout.centerImage({
    required String backgroundImage,
    required String centerImage,
    double borderRadius = 0,
    Key? key,
  }) {
    return ContainerLayout._(
      backgroundImage: backgroundImage,
      centerImage: centerImage,
      borderRadius: borderRadius,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
        image:
            backgroundImage != null
                ? DecorationImage(
                  image:
                      backgroundImage!.startsWith("http://")
                          ? NetworkImage(backgroundImage!)
                          : AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child: child,
    );
  }
}

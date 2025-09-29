import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key, this.width = 100, this.height = 100});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Lottie.asset(ImagePath.lottieFriend),
    );
  }
}

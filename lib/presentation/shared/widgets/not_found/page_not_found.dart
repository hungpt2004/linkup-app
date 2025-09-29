import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';

class PageNotFoundWidget extends StatelessWidget {
  const PageNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Lottie.asset(ImagePath.lottieError),
      ),
    );
  }
}

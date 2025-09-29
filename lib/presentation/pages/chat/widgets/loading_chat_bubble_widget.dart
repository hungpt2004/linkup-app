import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';

class LoadingChatBubbleWidget extends StatelessWidget {
  const LoadingChatBubbleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 8, left: 8, right: 50, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: SizedBox(
          width: 100,
          child: Lottie.asset(ImagePath.lottieLoading),
        ),
      ),
    );
  }
}

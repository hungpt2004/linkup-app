// Extension để dễ sử dụng
import 'package:flutter/material.dart';
import '../../themes/animation/animation_wrapper.dart';

extension AnimatedWrapperExtension on Widget {
  Widget animate({
    AnimationType type = AnimationType.fadeSlideUp,
    Duration duration = const Duration(milliseconds: 600),
    Duration delay = Duration.zero,
    Curve curve = Curves.easeOutCubic,
    bool autoStart = true,
    VoidCallback? onComplete,
  }) {
    return AnimatedWrapper(
      type: type,
      duration: duration,
      delay: delay,
      curve: curve,
      autoStart: autoStart,
      onAnimationComplete: onComplete,
      child: this,
    );
  }
}

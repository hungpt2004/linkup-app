import 'package:flutter/material.dart';

enum AnimationType {
  fade,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  scale,
  fadeSlideUp,
  fadeSlideDown,
  fadeSlideLeft,
  fadeSlideRight,
  bounceIn,
  elasticIn,
  rotateIn,
  flipIn,
}

class AnimatedWrapper extends StatefulWidget {
  final Widget child;
  final AnimationType type;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool autoStart;
  final VoidCallback? onAnimationComplete;

  const AnimatedWrapper({
    super.key,
    required this.child,
    this.type = AnimationType.fadeSlideUp,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.autoStart = true,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedWrapper> createState() => _AnimatedWrapperState();
}

class _AnimatedWrapperState extends State<AnimatedWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _setupAnimations();

    if (widget.autoStart) {
      _startAnimation();
    }
  }

  void _initializeController() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    if (widget.onAnimationComplete != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete!();
        }
      });
    }
  }

  void _setupAnimations() {
    // Fade Animation với curve mượt hơn
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 1.0, curve: widget.curve),
    );

    // Slide Animation với offset được tối ưu
    _slideAnimation = Tween<Offset>(
      begin: _getBeginOffset(widget.type),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: widget.curve),
      ),
    );

    // Scale Animation với range tự nhiên hơn
    _scaleAnimation = Tween<double>(
      begin: _getScaleBegin(widget.type),
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: widget.curve),
      ),
    );

    // Rotation Animation
    _rotationAnimation = Tween<double>(
      begin: _getRotationBegin(widget.type),
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: widget.curve),
      ),
    );
  }

  Offset _getBeginOffset(AnimationType type) {
    switch (type) {
      case AnimationType.slideUp:
      case AnimationType.fadeSlideUp:
        return const Offset(0, 0.5);
      case AnimationType.slideDown:
      case AnimationType.fadeSlideDown:
        return const Offset(0, -0.5);
      case AnimationType.slideLeft:
      case AnimationType.fadeSlideLeft:
        return const Offset(0.5, 0);
      case AnimationType.slideRight:
      case AnimationType.fadeSlideRight:
        return const Offset(-0.5, 0);
      case AnimationType.bounceIn:
        return const Offset(0, 1.0);
      case AnimationType.elasticIn:
        return const Offset(0, 0.3);
      default:
        return Offset.zero;
    }
  }

  double _getScaleBegin(AnimationType type) {
    switch (type) {
      case AnimationType.scale:
        return 0.7;
      case AnimationType.bounceIn:
        return 0.3;
      case AnimationType.elasticIn:
        return 0.5;
      case AnimationType.rotateIn:
      case AnimationType.flipIn:
        return 0.8;
      default:
        return 0.95;
    }
  }

  double _getRotationBegin(AnimationType type) {
    switch (type) {
      case AnimationType.rotateIn:
        return 0.5; // 180 degrees
      case AnimationType.flipIn:
        return 0.25; // 90 degrees
      default:
        return 0.0;
    }
  }

  // Curve _getAnimationCurve(AnimationType type) {
  //   switch (type) {
  //     case AnimationType.bounceIn:
  //       return Curves.bounceOut;
  //     case AnimationType.elasticIn:
  //       return Curves.elasticOut;
  //     case AnimationType.rotateIn:
  //     case AnimationType.flipIn:
  //       return Curves.easeOutBack;
  //     default:
  //       return widget.curve;
  //   }
  // }

  void _startAnimation() {
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  // Public method để trigger animation từ bên ngoài
  void startAnimation() {
    if (mounted) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return _buildAnimatedWidget();
      },
    );
  }

  Widget _buildAnimatedWidget() {
    switch (widget.type) {
      case AnimationType.fade:
        return FadeTransition(opacity: _fadeAnimation, child: widget.child);

      case AnimationType.scale:
        return ScaleTransition(scale: _scaleAnimation, child: widget.child);

      case AnimationType.slideUp:
      case AnimationType.slideDown:
      case AnimationType.slideLeft:
      case AnimationType.slideRight:
        return SlideTransition(position: _slideAnimation, child: widget.child);

      case AnimationType.fadeSlideUp:
      case AnimationType.fadeSlideDown:
      case AnimationType.fadeSlideLeft:
      case AnimationType.fadeSlideRight:
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
        );

      case AnimationType.bounceIn:
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
          ),
        );

      case AnimationType.elasticIn:
        return SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
          ),
        );

      case AnimationType.rotateIn:
        return RotationTransition(
          turns: _rotationAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
          ),
        );

      case AnimationType.flipIn:
        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(_rotationAnimation.value * 3.14159), // pi radians
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(opacity: _fadeAnimation, child: widget.child),
          ),
        );

      // ignore: unreachable_switch_default
      default:
        return FadeTransition(opacity: _fadeAnimation, child: widget.child);
    }
  }
}

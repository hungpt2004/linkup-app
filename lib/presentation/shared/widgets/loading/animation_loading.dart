import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class AnimationLoadingWidget extends StatefulWidget {
  const AnimationLoadingWidget({super.key});

  @override
  State<AnimationLoadingWidget> createState() =>
      _AnimationLoadingWidgeState();
}

// Thêm SingleTickerProviderStateMixin để hỗ trợ animation
class _AnimationLoadingWidgeState extends State<AnimationLoadingWidget>
    with SingleTickerProviderStateMixin {
  // Khai báo AnimationController để điều khiển animation
  late AnimationController _animationController;
  // Khai báo Animation để định nghĩa giá trị animation từ 0 đến 2π (một vòng tròn)
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    // Khởi tạo AnimationController với thời lượng 2 giây
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this, // SingleTickerProviderStateMixin cung cấp vsync
    );

    // Tạo Tween animation từ 0 đến 2π (360 độ) để xoay một vòng tròn
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // 2π radians = 360 độ
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear, // Xoay đều không có gia tốc
      ),
    );

    // Bắt đầu animation và lặp lại vô hạn
    _animationController.repeat();
  }

  @override
  void dispose() {
    // Giải phóng AnimationController khi widget bị hủy để tránh memory leak
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sử dụng AnimatedBuilder để rebuild widget khi animation thay đổi
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                // Transform.rotate để xoay container theo giá trị animation
                return Transform.rotate(
                  angle: _rotationAnimation.value, // Góc xoay từ animation
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: context.colorScheme.primary,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.white,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

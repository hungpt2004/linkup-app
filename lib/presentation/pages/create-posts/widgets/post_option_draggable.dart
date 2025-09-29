import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/mock/mock_data.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/widgets/post_option_section_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class FormOptionDraggable extends StatefulWidget {
  final void Function(String type)? onOptionTap;
  const FormOptionDraggable({super.key, this.onOptionTap});

  @override
  State<FormOptionDraggable> createState() => _FormOptionDraggableState();
}

class _FormOptionDraggableState extends State<FormOptionDraggable>
    with WidgetsBindingObserver {
  // Thêm WidgetsBindingObserver

  final ValueNotifier<bool> _isExpandedNotifier = ValueNotifier<bool>(false);
  final DraggableScrollableController _sheetController =
      DraggableScrollableController(); // Controller để điều khiển DraggableScrollableSheet

  // Định nghĩa các giá trị min/initial/max extent của sheet
  static const double _initialChildSize = 0.15;
  static const double _minChildSize = 0.10;
  static const double _maxChildSize = 0.8;
  static const double _expansionThreshold =
      0.3; // Ngưỡng để chuyển đổi giữa ngang và dọc

  @override
  void initState() {
    super.initState();
    // Đăng ký observer để lắng nghe sự kiện thay đổi layout
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _isExpandedNotifier.dispose();
    _sheetController.dispose();
    // Hủy đăng ký observer khi widget không còn được sử dụng
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Phương thức được gọi khi kích thước layout của ứng dụng thay đổi.
  /// Thường được kích hoạt khi bàn phím ảo xuất hiện hoặc ẩn đi. - didChangeMetrics
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Lấy chiều cao của bàn phím ảo
    final double keyboardHeight =
        // ignore: deprecated_member_use
        WidgetsBinding.instance.window.viewInsets.bottom;

    // Nếu bàn phím đang hiển thị (chiều cao > 0)
    if (keyboardHeight > 0) {
      // Nếu sheetController đã được gắn (attached) với DraggableScrollableSheet
      if (_sheetController.isAttached) {
        // Thu gọn sheet về minChildSize
        _sheetController.animateTo(
          _minChildSize, // Sử dụng giá trị _minChildSize đã định nghĩa
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
        );
        // Cập nhật trạng thái hiển thị là thu gọn (ngang)
        _isExpandedNotifier.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final double currentSheetExtent = notification.extent;
        final bool shouldBeExpanded = currentSheetExtent > _expansionThreshold;

        if (_isExpandedNotifier.value != shouldBeExpanded) {
          _isExpandedNotifier.value = shouldBeExpanded;
        }
        return false; // Trả về false để cho phép các NotificationListener khác cũng nhận được thông báo
      },
      child: DraggableScrollableSheet(
        controller: _sheetController, // Gán controller đã tạo
        expand: true,
        initialChildSize: _initialChildSize,
        minChildSize: _minChildSize,
        maxChildSize: _maxChildSize,
        builder: (context, scrollController) {
          return Material(
            color: Colors.transparent,
            child: Container(
              decoration: _decorationPostOptionContainer(),
              child: Column(
                children: [
                  _buildDividerBottomSheet(context),
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isExpandedNotifier,
                      builder: (context, isExpanded, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child:
                              isExpanded
                                  // 3. Dùng key để AnimatedSwitcher nhận biết widget đã thay đổi
                                  ? CustomScrollView(
                                    key: const ValueKey(
                                      'vertical_list',
                                    ), // Key cho layout dọc
                                    controller: scrollController,
                                    slivers: [
                                      _bodyListOptionVertical(
                                        widget.onOptionTap,
                                      ),
                                    ],
                                  )
                                  : CustomScrollView(
                                    key: const ValueKey(
                                      'horizontal_list',
                                    ), // Key cho layout ngang
                                    controller: scrollController,
                                    slivers: [
                                      _bodyListOptionHorizontal(
                                        widget.onOptionTap,
                                      ),
                                    ],
                                  ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Phương thức giúp trang trí cho Container chính của DraggableSheet.
  BoxDecoration _decorationPostOptionContainer() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          offset: const Offset(0, -4),
          blurRadius: 12,
          spreadRadius: 2,
        ),
      ],
    );
  }
}

/// Widget riêng cho thanh kéo (divider) ở đầu sheet.
/// Nhấn vào thanh này có thể đóng sheet.
Widget _buildDividerBottomSheet(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    width: ResponsiveSizeApp(context).screenWidth * 0.15,
    height: 5.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      color: AppColor.lightGrey,
    ),
  );
}

Widget _bodyListOptionVertical(Function(String type)? onOptionTap) {
  return SliverList(
    delegate: SliverChildBuilderDelegate((context, idx) {
      final option = MockData.postOptions[idx];
      return PaddingLayout.symmetric(
        horizontal: 15,
        vertical: 5,
        child: PostOptionWidget(
          onTap: () => onOptionTap?.call(option['type'] ?? ''),
          iconPath: option['icon'] ?? '',
          name: option['name'] ?? '',
        ),
      );
    }, childCount: MockData.postOptions.length),
  );
}

Widget _bodyListOptionHorizontal(Function(String type)? onOptionTap) {
  return SliverToBoxAdapter(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(),
        child: SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.postOptions.length,
            padding: EdgeInsets.symmetric(
              horizontal: PaddingSizeApp.paddingSizeSmall,
            ),
            separatorBuilder: (_, __) => WSpacing(12),
            itemBuilder: (context, idx) {
              final option = MockData.postOptions[idx];
              return GestureDetector(
                onTap: () => onOptionTap?.call(option['type'] ?? ''),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: ResponsiveSizeApp(context).widthPercent(56),
                      height: ResponsiveSizeApp(context).heightPercent(50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          option['icon'],
                          width: ResponsiveSizeApp(context).widthPercent(30),
                          height: ResponsiveSizeApp(context).widthPercent(30),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'image_view_interact_widget.dart';

class PhotoTileWidget extends StatelessWidget {
  final String imageUrl;
  final int? remainingCount;
  final BuildContext createPostContext;
  final BoxFit imagefit;
  final String mode;
  final List<String>? allImages; // Add support for all images
  final int? imageIndex; // Add support for current image index

  const PhotoTileWidget({
    super.key,
    required this.imageUrl,
    this.remainingCount,
    required this.createPostContext,
    this.imagefit = BoxFit.cover,
    required this.mode,
    this.allImages,
    this.imageIndex,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Base Image Widget - đảm bảo nó fill và cover
    Widget baseImageWidget = Container(
      color: Colors.blue.withValues(alpha: 0.3), // Màu nền để xem kích thước
      width: double.infinity,
      height: double.infinity,
      child: MyImageWidget(
        imageUrl: imageUrl,
        imageWidth: double.infinity,
        imageHeight: double.infinity,
        fit: imagefit,
      ),
    );

    Widget content;

    // 2. Logic cho Remaining Count Overlay
    if (remainingCount != null && remainingCount! > 0) {
      content = Stack(
        fit:
            StackFit
                .expand, // Stack sẽ lấp đầy toàn bộ không gian của PhotoTileWidget
        children: [
          baseImageWidget, // Ảnh nền, phải được cover
          Container(
            color: Colors.black.withValues(
              alpha: 0.5,
            ), // Sử dụng withOpacity an toàn hơn
            alignment:
                Alignment
                    .center, // Căn giữa nội dung (Text) trong Container này
            child: Text(
              '+$remainingCount',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize:
                    28, // Tăng font size một chút để dễ nhìn, nhưng cẩn thận tràn
                // Các thuộc tính quan trọng để tránh tràn và căn giữa
                height: 1.0, // Đặt line height để kiểm soát khoảng cách dòng
              ),
              textAlign:
                  TextAlign.center, // Căn giữa Text trong không gian của nó
              maxLines: 1, // Chỉ cho phép 1 dòng
              overflow:
                  TextOverflow
                      .visible, // Để lỗi tràn rõ ràng hơn trong debug nếu có,
              // hoặc TextOverflow.clip / TextOverflow.ellipsis
              // nếu bạn muốn cắt bớt.
            ),
          ),
        ],
      );
    } else {
      content = baseImageWidget;
    }

    return GestureDetector(
      onTap: () {
        // Different behavior based on mode
        switch (mode) {
          case 'edit':
            // Edit mode: navigate to edit screen
            AppNavigator.toEditImaegScreen(createPostContext, mode: mode);
            break;
          case 'post':
          case 'view':
          default:
            // Post/View mode: open image viewer
            if (allImages != null && allImages!.isNotEmpty) {
              Navigator.of(createPostContext).push(
                MaterialPageRoute(
                  builder:
                      (context) => ImageViewerScreen(
                        images: allImages!,
                        tag: 'post_image_${imageIndex ?? 0}',
                      ),
                ),
              );
            }
            break;
        }
      },
      child: content,
    );
  }
}

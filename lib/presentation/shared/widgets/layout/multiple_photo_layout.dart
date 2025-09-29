import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post-images/image_item_widget.dart';

class MultiplePhotoLayout extends StatelessWidget {
  final List<String> imageUrls;
  final BuildContext createPostContext;
  final String mode;

  const MultiplePhotoLayout({
    super.key,
    required this.imageUrls,
    required this.createPostContext,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    // Nếu vẫn muốn có AspectRatio tổng thể (cho các trường hợp cụ thể)
    return AspectRatio(
      aspectRatio: _getAspectRatio(imageUrls.length),
      child: StaggeredGrid.count(
        crossAxisCount: _getCrossAxisCount(imageUrls.length),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: _buildStaggeredTiles(imageUrls),
      ),
    );
  }

  // Phương thức để xác định tỷ lệ khung hình tổng thể
  double _getAspectRatio(int count) {
    if (count >= 4 || count == 1 || count == 3) return 1;
    return 16 / 9;
  }

  int _getCrossAxisCount(int count) {
    if (count == 1) return 1;
    return 2;
  }

  // Phương thức chính để xây dựng danh sách các StaggeredGridTile
  List<StaggeredGridTile> _buildStaggeredTiles(List<String> imageUrls) {
    final int count = imageUrls.length;

    switch (count) {
      case 1:
        return [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: PhotoTileWidget(
              imageUrl: imageUrls[0],
              createPostContext: createPostContext,
              mode: mode,
              allImages: imageUrls,
              imageIndex: 0,
            ),
          ),
        ];
      case 2:
        return [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: PhotoTileWidget(
              imageUrl: imageUrls[0],
              createPostContext: createPostContext,
              mode: mode,
              allImages: imageUrls,
              imageIndex: 0,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: PhotoTileWidget(
              imageUrl: imageUrls[1],
              createPostContext: createPostContext,
              mode: mode,
              allImages: imageUrls,
              imageIndex: 1,
            ),
          ),
        ];
      case 3:
        return [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 2, // Trái lớn
            child: PhotoTileWidget(
              imageUrl: imageUrls[0],
              createPostContext: createPostContext,
              mode: mode,
              allImages: imageUrls,
              imageIndex: 0,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1, // Phải trên
            child: PhotoTileWidget(
              imageUrl: imageUrls[1],
              createPostContext: createPostContext,
              mode: mode,
              allImages: imageUrls,
              imageIndex: 1,
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1, // Phải dưới
            child: PhotoTileWidget(
              imageUrl: imageUrls[2],
              createPostContext: createPostContext,
              mode: mode,
              allImages: imageUrls,
              imageIndex: 2,
            ),
          ),
        ];
      default: // Xử lý cho count >= 4
        final int displayTileCount = 4;
        List<StaggeredGridTile> tiles = [];

        // Hàng trên: 2 ảnh nhỏ lại (ví dụ chiều cao 150px)
        // Chúng ta sẽ dùng StaggeredGridTile.fit và bọc PhotoTileWidget trong SizedBox để giới hạn chiều cao
        const double topRowHeight = 200; // Thử nghiệm giá trị này
        const double bottomRowHeight =
            180; // Thử nghiệm giá trị này (nhỏ hơn nữa)

        for (int i = 0; i < 2; i++) {
          tiles.add(
            StaggeredGridTile.fit(
              // <-- SỬ DỤNG StaggeredGridTile.fit
              crossAxisCellCount: 1, // Vẫn chiếm 1/2 chiều rộng
              child: SizedBox(
                // <-- BỌC TRONG SIZEDBOX ĐỂ ÉP CHIỀU CAO TỐI ĐA
                height: topRowHeight,
                child: PhotoTileWidget(
                  imageUrl: imageUrls[i],
                  createPostContext: createPostContext,
                  mode: mode,
                  allImages: imageUrls,
                  imageIndex: i,
                  // Không cần intrinsicAspectRatio ở đây nếu PhotoTileWidget dùng BoxFit.contain
                ),
              ),
            ),
          );
        }

        // Hàng dưới: 2 ảnh nhỏ hơn nữa (ví dụ chiều cao 100px)
        for (int i = 2; i < displayTileCount; i++) {
          final int currentImageIndex = i;

          if (i == displayTileCount - 1 && count > displayTileCount) {
            tiles.add(
              StaggeredGridTile.fit(
                // <-- SỬ DỤNG StaggeredGridTile.fit
                crossAxisCellCount: 1,
                child: SizedBox(
                  // <-- BỌC TRONG SIZEDBOX ĐỂ ÉP CHIỀU CAO TỐI ĐA
                  height: bottomRowHeight,
                  child: PhotoTileWidget(
                    imageUrl: imageUrls[currentImageIndex],
                    remainingCount: count - displayTileCount,
                    createPostContext: createPostContext,
                    mode: mode,
                    allImages: imageUrls,
                    imageIndex: currentImageIndex,
                  ),
                ),
              ),
            );
          } else {
            tiles.add(
              StaggeredGridTile.fit(
                crossAxisCellCount: 1,
                child: SizedBox(
                  height: bottomRowHeight,
                  child: PhotoTileWidget(
                    imageUrl: imageUrls[currentImageIndex],
                    createPostContext: createPostContext,
                    mode: mode,
                    allImages: imageUrls,
                    imageIndex: currentImageIndex,
                  ),
                ),
              ),
            );
          }
        }
        return tiles;
    }
  }
}

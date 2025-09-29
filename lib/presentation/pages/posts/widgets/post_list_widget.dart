import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/shared/widgets/skeletionizer_loading/card_post_skeletionizer_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

// RELATIVE IMPORT
import 'post_section_widget.dart';

class PostListWidget extends StatefulWidget {
  const PostListWidget({super.key});

  @override
  State<PostListWidget> createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget>
    with AutomaticKeepAliveClientMixin {
  final bool _showCachedPostsOnly = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Observer(
      key: ValueKey('posts_observer'),
      builder: (_) {
        final postStore = context.postStore;
        final friendStore = context.friendStore;

        // Check if we should show cached posts only or all posts
        final shouldShowCachedOnly =
            _showCachedPostsOnly && postStore.isLoadedFromCache;
        final postsToShow =
            shouldShowCachedOnly
                ? postStore.posts.take(10).toList()
                : postStore.posts;

        // Kiểm tra trạng thái wifi
        // final isWifi = context.netWorkStore.isWifi;
        // final isConnected = context.netWorkStore.isConnected;

        // Hiển thị skeleton khi:
        // 1. Đang initializing (lần đầu vào app)
        // 2. Đang loading và chưa có posts (refresh hoàn toàn)
        final shouldShowSkeleton =
            postStore.isInitializing ||
            (postStore.isLoading && postStore.posts.isEmpty);

        if (shouldShowSkeleton) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const CardPostSkeletonWidget(),
              childCount: 10,
            ),
          );
        }

        // Nếu không có friend thì sẽ hiện như này
        if (postStore.posts.isEmpty && friendStore.friends.isEmpty) {
          return SliverFillRemaining(
            key: ValueKey('error_empty'),
            child: Center(
              child: SizedBox(
                width: ResponsiveSizeApp(context).widthPercent(200),
                height: ResponsiveSizeApp(context).heightPercent(200),
                child: ClipRRect(child: Lottie.asset(ImagePath.lottieFriend)),
              ),
            ),
          );
        }

        // Error state when no posts
        if (postStore.hasError && postStore.posts.isEmpty) {
          return SliverFillRemaining(
            key: ValueKey('error_empty'),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    postStore.errorMessage ?? 'Có lỗi xảy ra',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => postStore.refresh(),
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }

        final createStore = context.createPostStore;
        final createPostLoading = createStore.isLoading;

        return SliverList(
          key: ValueKey('posts_list'),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (createPostLoading &&
                  index == (shouldShowCachedOnly ? 1 : 0)) {
                return PaddingLayout.symmetric(
                  vertical: 5,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: AppColor.mediumGrey,
                    color: AppColor.lightBlue,
                  ),
                );
              }

              // Show load more indicator at the end
              final loadMoreIndex =
                  postsToShow.length +
                  (createPostLoading ? 1 : 0) +
                  (shouldShowCachedOnly ? 1 : 0);
              if (index == loadMoreIndex) {
                if (postStore.isLoading && postStore.hasMorePosts) {
                  return Padding(
                    key: ValueKey('loading_more'),
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: SizedBox(
                        width: ResponsiveSizeApp(context).widthPercent(24),
                        height: ResponsiveSizeApp(context).heightPercent(24),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }

              // Adjust index for createPostLoading offset và cache indicator
              final postIndex =
                  createPostLoading
                      ? (shouldShowCachedOnly ? index - 2 : index - 1)
                      : (shouldShowCachedOnly ? index - 1 : index);
              if (postIndex < 0 || postIndex >= postsToShow.length) {
                return SizedBox.shrink();
              }

              final post = postsToShow[postIndex];
              return RepaintBoundary(
                child: PostSectionWidget(
                  key: ValueKey('post_${post.id}'),
                  post: post,
                ),
              );
            },
            childCount:
                postsToShow.length +
                (createPostLoading ? 1 : 0) +
                (shouldShowCachedOnly ? 1 : 0) +
                (postStore.isLoading && postStore.hasMorePosts ? 1 : 0),
            findChildIndexCallback: (Key key) {
              if (key is ValueKey<String>) {
                final stringKey = key.value;
                if (stringKey.startsWith('post_')) {
                  final postId = stringKey.substring(5);
                  final index = postsToShow.indexWhere(
                    (post) => post.id == postId,
                  );
                  if (index >= 0) {
                    return index +
                        (context.createPostStore.isLoading ? 1 : 0) +
                        (shouldShowCachedOnly ? 1 : 0);
                  }
                }
              }
              return null;
            },
          ),
        );
      },
    );
  }

  // Hết viewport -> dispose
  @override
  bool get wantKeepAlive => false;
}

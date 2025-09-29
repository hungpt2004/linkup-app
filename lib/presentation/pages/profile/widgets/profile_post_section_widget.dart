import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_section_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

class ProfilePostSection extends StatelessWidget {
  const ProfilePostSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profilePostStore = context.profilePostStore;

    return Observer(
      builder: (_) {
        // Loading state when no posts
        if (profilePostStore.isLoading && profilePostStore.ownPosts.isEmpty) {
          return SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Error state when no posts
        if (profilePostStore.hasError && profilePostStore.ownPosts.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    profilePostStore.errorMessage ?? 'Có lỗi xảy ra',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => profilePostStore.loadOwnPosts(refresh: true),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (profilePostStore.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có bài viết nào',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Posts list
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // Loading indicator at the end
              if (index == profilePostStore.ownPosts.length) {
                if (profilePostStore.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }

              final post = profilePostStore.ownPosts[index];
              return RepaintBoundary(
                child: PostSectionWidget(
                  key: ValueKey('own_post_${post.id}'),
                  post: post,
                ),
              );
            },
            childCount:
                profilePostStore.ownPosts.length +
                (profilePostStore.isLoading ? 1 : 0),
          ),
        );
      },
    );
  }
}

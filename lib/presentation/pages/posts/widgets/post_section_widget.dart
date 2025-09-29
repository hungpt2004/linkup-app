import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/multiple_photo_layout.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/utils/check_is_url.dart';
import 'package:vdiary_internship/presentation/shared/widgets/divider/divider_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';

// RELATIVE IMPORT
import 'post_item_header_widget.dart';
import 'post_item_actions_widget.dart';
import 'post_item_caption_widget.dart';
import 'post_item_stats_widget.dart';
import 'post-videos/post_video_list_widget.dart';

// Import store extensions to access CreatePostStore
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';

class PostSectionWidget extends StatefulWidget {
  const PostSectionWidget({super.key, required this.post});

  final PostModel post;

  @override
  State<PostSectionWidget> createState() => _PostSectionWidgetState();
}

class _PostSectionWidgetState extends State<PostSectionWidget> {
  @override
  Widget build(BuildContext context) {
    final List<String> foundUrls = findAllUrls(widget.post.caption);
    final currentPost = widget.post;

    return Observer(
      builder: (_) {
        // Check if this post is an offline post
        final createPostStore = context.createPostStore;
        final isOfflinePost = createPostStore.postNeedWifi.any(
          (post) => post.id == widget.post.id,
        );

        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Time, Privacy
            PostHeaderSectionWidget(post: widget.post),

            // Content & Hashtags
            PostCaptionSectionWidget(urls: foundUrls, post: currentPost),

            // Summary Text
            HSpacing(10),

            // Images Layout (if exists)
            if (widget.post.images.isNotEmpty) _buildImagesLayout(context),

            // Videos Layout (if exists) - Wrapped với unique key cho mỗi post
            if (widget.post.videos.isNotEmpty)
              Container(
                key: ValueKey('video_${widget.post.id}'),
                child: _buildVideosLayout(context),
              ),

            // Links (if exists)
            if (widget.post.links.isNotEmpty) _buildLinksSection(context),

            HSpacing(15),

            // Like, Comment count
            PostStatsWidget(post: currentPost),

            HSpacing(15),

            // Action buttons
            PostActionsWidget(postId: currentPost.id, post: currentPost),

            HSpacing(10),

            DividerWidget(height: 4),
          ],
        );

        // Add gray overlay if this is an offline post
        if (isOfflinePost) {
          content = Stack(
            children: [
              content,
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.wifi_off_20_regular,
                          size: 48,
                          color: Colors.white,
                        ),
                        Text(
                          'Waiting for WiFi',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppColor.backgroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Post will be published when WiFi is available',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColor.backgroundColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return GestureDetector(
          onTap: () {
            // Prevent navigation to post detail for offline posts
            if (!isOfflinePost) {
              AppNavigator.goNamed(context, 'postDetail', extra: widget.post);
            }
          },
          child: SizedBox(child: content),
        );
      },
    );
  }

  Widget _buildImagesLayout(BuildContext context) {
    if (widget.post.images.isEmpty) return const SizedBox.shrink();

    return MultiplePhotoLayout(
      imageUrls: widget.post.images,
      createPostContext: context,
      mode: TypeMode.post.name,
    );
  }

  Widget _buildVideosLayout(BuildContext context) {
    if (widget.post.videos.isEmpty) return const SizedBox.shrink();

    return PostVideoLayout(videoUrls: widget.post.videos);
  }

  Widget _buildLinksSection(BuildContext context) {
    if (widget.post.links.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        HSpacing(8),
        PaddingLayout.symmetric(
          horizontal: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.from(
              widget.post.links.map((link) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.link_16_regular,
                        color: AppColor.mediumGrey,
                      ),
                      WSpacing(8),
                      Expanded(
                        child: Text(
                          link.url,
                          style: TextStyle(
                            fontSize: FontSizeApp.fontSizeSmall,
                            color: context.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

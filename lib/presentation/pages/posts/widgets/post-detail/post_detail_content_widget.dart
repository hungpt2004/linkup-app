import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post_item_actions_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/multiple_photo_layout.dart';
import 'package:vdiary_internship/presentation/shared/utils/check_is_url.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../post-videos/post_video_list_widget.dart';
import '../post_item_caption_widget.dart';

class PostDetailContentWidget extends StatelessWidget {
  const PostDetailContentWidget({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final currentPost = post;
    final List<String> foundUrls = findAllUrls(currentPost.caption);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Use the same caption component as post list for consistency
        PostCaptionSectionWidget(urls: foundUrls, post: currentPost),

        HSpacing(10),

        // Images Layout (if exists)
        if (currentPost.images.isNotEmpty)
          _buildImagesLayout(context, currentPost),

        // Videos Layout (if exists)
        if (currentPost.videos.isNotEmpty)
          _buildVideosLayout(context, currentPost),

        // Links (if exists)
        if (currentPost.links.isNotEmpty)
          _buildLinksSection(context, currentPost),

        HSpacing(10),

        PostActionsWidget(postId: currentPost.id, post: currentPost),
      ],
    );
  }

  Widget _buildImagesLayout(BuildContext context, PostModel post) {
    if (post.images.isEmpty) return const SizedBox.shrink();
    return PaddingLayout.all(
      value: 0,
      child: MultiplePhotoLayout(
        imageUrls: post.images,
        createPostContext: context,
        // TODO: MODE ẢNH CỦA DETAIL
        mode: TypeMode.edit.name,
      ),
    );
  }

  Widget _buildVideosLayout(BuildContext context, PostModel post) {
    if (post.videos.isEmpty) return const SizedBox.shrink();
    return PaddingLayout.all(
      value: 0,
      child: PostVideoLayout(videoUrls: post.videos),
    );
  }

  Widget _buildLinksSection(BuildContext context, PostModel post) {
    if (post.links.isEmpty) return SizedBox.shrink();
    return Column(
      children: [
        HSpacing(8),
        PaddingLayout.symmetric(
          horizontal: 25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                post.links.map((link) {
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
                }).toList(),
          ),
        ),
      ],
    );
  }
}

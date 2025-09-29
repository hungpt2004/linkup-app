import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/shared/widgets/link_preview_generator/link_preview_card_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../../create-posts/utils/caption_build_utils.dart';

class PostCaptionSectionWidget extends StatelessWidget {
  const PostCaptionSectionWidget({super.key, required this.urls, this.post});

  final List<String> urls;
  final PostModel? post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mentions
        if (post?.mentions.isNotEmpty ?? false) ...[
          HSpacing(8),
          _buildMentionSection(context),
        ],

        // Caption
        if (post!.caption.isNotEmpty)
          PaddingLayout.symmetric(
            horizontal: 20,
            child: buildCaption(post!.caption, context, () {}),
          ),

        if (urls.isNotEmpty)
          ...urls.map((url) => LinkPreviewCardWidget(url: url)),

        // Hashtags
        if (post!.hashtags.isNotEmpty) ...[
          HSpacing(8),
          _buildHastagSection(context),
        ],

        // Summary Text
        Observer(
          builder: (_) {
            final chatStore = context.chatStore;
            final mapPostAndSummary = chatStore.postIdsAndContentMap;
            final postId = post?.id;
            if (postId == null || !mapPostAndSummary.containsKey(postId)) {
              return const SizedBox.shrink();
            }

            return PaddingLayout.symmetric(
              horizontal: 22,
              vertical: 10,
              child:
                  chatStore.postIdsAndContentMap[postId] == null
                      ? LinearProgressIndicator(color: AppColor.successGreen)
                      : Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.successGreen,
                            width: 1,
                          ),
                          color: AppColor.successGreen.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PaddingLayout.all(
                          value: 10,
                          child: Text(
                            mapPostAndSummary[postId]!,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColor.successGreen,
                            ),
                          ),
                        ),
                      ),
            );
          },
        ),
      ],
    );
  }

  // Build hashtag section
  Widget _buildHastagSection(BuildContext context) {
    return PaddingLayout.symmetric(
      horizontal: 25,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: List<Widget>.from(
          post!.hashtags.map((hashtag) {
            return Text(
              '#${hashtag.name}',
              style: TextStyle(
                fontSize: FontSizeApp.fontSizeSmall,
                fontWeight: FontWeight.w500,
                color: context.colorScheme.primary,
              ),
            );
          }),
        ),
      ),
    );
  }

  // Build mention section
  Widget _buildMentionSection(BuildContext context) {
    return PaddingLayout.symmetric(
      horizontal: 20,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: List<Widget>.from(
          post!.mentions.map((mention) {
            return Text(
              '@${mention.displayName}',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColor.lightBlue,
              ),
            );
          }),
        ),
      ),
    );
  }
}

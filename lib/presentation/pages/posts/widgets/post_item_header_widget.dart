// FULL PACKAGE IMPORT
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/pages/chat/controller/chat_controller.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../controllers/post_controller.dart';

class PostHeaderSectionWidget extends StatefulWidget {
  const PostHeaderSectionWidget({super.key, required this.post});

  final PostModel post;

  @override
  State<PostHeaderSectionWidget> createState() => _HeaderCardPostWidgetState();
}

class _HeaderCardPostWidgetState extends State<PostHeaderSectionWidget> {
  late PostController postController;
  late ChatController chatController;

  @override
  void didChangeDependencies() {
    postController = PostController(postStoreRef: context.postStore);
    chatController = ChatController(chatStore: context.chatStore);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PaddingLayout.symmetric(
      child: ListTile(
        // Avatar
        leading: _listTileLeadingAvatar(
          widget.post.user.avatarUrl ?? '',
          context,
        ),

        // Title
        title: Row(
          children: [
            Text(
              widget.post.user.name ?? 'Unknown User',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            WSpacing(2),
            if (widget.post.user.verified)
              Icon(Icons.verified, size: 16, color: Colors.blue),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              '${formatTimeAgo(widget.post.createdAt.toString())}・',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.mediumGrey,
              ),
            ),
            SizedBox(
              width: 12,
              height: 12,
              child: SvgPicture.asset(
                widget.post.privacy == 'public'
                    ? ImagePath.earthIcon
                    : ImagePath.friendOptionIcon,
              ),
            ),
          ],
        ),

        // Menu button
        trailing: Observer(
          builder: (_) {
            final authStore = context.authStore;
            final currentUserId = authStore.userInfo?['_id'] ?? '';
            final postAuthorId = widget.post.user.id ?? '';

            // Kiểm tra xem user hiện tại có phải owner của post không
            final isOwner = postController.canEditPost(
              postAuthorId,
              currentUserId,
            );

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    ImagePath.menuBlackIcon,
                    width: 15,
                    height: 15,
                  ),
                  onPressed: () {
                    if (isOwner) {
                      // Hiển thị options cho owner (edit/delete)
                      postController.showPostOwnerOptions(
                        context,
                        widget.post.id,
                        widget.post,
                      );
                    } else {
                      // Hiển thị options cho user khác (report/hide)
                      postController.showPostReportOptionBottomSheet(context);
                    }
                  },
                ),

                // AI Summary button
                GestureDetector(
                  onTap:
                      () => chatController.sendRequestSummaryText(
                        context,
                        widget.post.id,
                        widget.post.caption,
                      ),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: AppColor.mediumGrey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: PaddingLayout.all(
                        value: 3,
                        child: SvgPicture.asset(ImagePath.aiIcon),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _listTileLeadingAvatar(String imageUrl, BuildContext context) {
  return SizedBox(
    width: ResponsiveSizeApp(context).widthPercent(50),
    height: ResponsiveSizeApp(context).heightPercent(50),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: MyImageWidget(imageUrl: imageUrl),
    ),
  );
}

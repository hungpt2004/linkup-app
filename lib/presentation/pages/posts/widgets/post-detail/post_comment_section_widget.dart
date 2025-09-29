import 'package:comment_tree/data/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/post/comment_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/controllers/post_controller.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';

class PostCommentSectionWidget extends StatelessWidget {
  const PostCommentSectionWidget({
    super.key,
    required this.commentItem,
    this.postController,
    this.onReply,
  });

  final CommentModel? commentItem;
  final PostController? postController;
  final Function(String)? onReply;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final allComments = context.postStore.listComments;
        debugPrint('------> DS LIST COMMENTS: ${allComments.length}');
        final rootComments = buildCommentTree(allComments);
        debugPrint('------> DS LIST ROOT COMMENTS: ${rootComments.length}');
        final Map<String, CommentModel> allCommentsMap = {
          for (var comment in allComments.where(isValidComment))
            comment.id!: comment,
        };
        return Column(
          children:
              rootComments.map((comment) {
                return CommentTreeWidget<Comment, Comment>(
                  mapToComment(comment),
                  comment.replies
                          ?.map((reply) => mapToComment(reply))
                          .toList() ??
                      [],
                  treeThemeData: TreeThemeData(
                    lineColor: AppColor.lightGrey,
                    lineWidth: 1,
                  ),
                  avatarRoot:
                      (context, data) => PreferredSize(
                        preferredSize: const Size.fromRadius(18),
                        child: AvatarBoxShadowWidget(
                          imageUrl: data.avatar ?? ImagePath.avatarDefault,
                          width: 36,
                          height: 36,
                        ),
                      ),
                  avatarChild:
                      (context, data) => PreferredSize(
                        preferredSize: const Size.fromRadius(18),
                        child: AvatarBoxShadowWidget(
                          imageUrl: data.avatar ?? ImagePath.avatarDefault,
                          width: 36,
                          height: 36,
                        ),
                      ),
                  contentRoot: (context, data) {
                    return _buildCommentContent(
                      context,
                      comment,
                      postController!,
                    );
                  },
                  contentChild: (context, data) {
                    final childCommentModel = allCommentsMap[data.userName];
                    return _buildCommentContent(
                      context,
                      childCommentModel ?? CommentModel(),
                      postController!,
                    );
                  },
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildCommentContent(
    BuildContext context,
    CommentModel commentItem,
    PostController postController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: ResponsiveSizeApp(context).widthPercent(300),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColor.superLightGrey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                commentItem.author?.name ?? 'Unknown',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                commentItem.text ?? 'Can not loading this ',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                formatTimeAgo(commentItem.createdAt ?? DateTime.now()),
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            WSpacing(10),
            Text(
              'Like',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            WSpacing(10),
            GestureDetector(
              onTap: () async {
                final authorName = commentItem.author?.name ?? 'Unknown';
                postController.postStoreRef.setReplyInputValue(authorName);
              },
              child: Text(
                'Reply',
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Observer(
              builder: (_) {
                final authStore = context.authStore;
                final currentUserInforId = authStore.userInfo?['_id'] ?? '';
                final commentAuthorId = commentItem.author?.id ?? '';
                final isAuthor = postController.canEditComment(
                  commentAuthorId,
                  currentUserInforId,
                );
                return isAuthor
                    ? PopupMenuButton<String>(
                      popUpAnimationStyle: AnimationStyle(
                        curve: Curves.bounceInOut,
                      ),
                      position: PopupMenuPosition.under,
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset(
                        ImagePath.menuBlackIcon,
                        width: 20,
                        height: 20,
                      ),
                      itemBuilder:
                          (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              height: 0,
                              value: 'edit',
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagePath.editIcon,
                                    width: 15,
                                    height: 15,
                                  ),
                                  WSpacing(8),
                                  Text(
                                    'Edit',
                                    style: context.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              height: 0,
                              value: 'delete',
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    ImagePath.deleteIcon,
                                    width: 15,
                                    height: 15,
                                  ),
                                  WSpacing(8),
                                  Text(
                                    'Delete',
                                    style: context.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                      onSelected: (String result) {
                        switch (result) {
                          case 'edit':
                            debugPrint('Bạn đã chọn Chỉnh sửa');
                            break;
                          case 'delete':
                            postController.showDeleteCommentConfirmDialog(
                              context,
                              commentItem.id!,
                            );
                            break;
                        }
                      },
                    )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ],
    );
  }
}

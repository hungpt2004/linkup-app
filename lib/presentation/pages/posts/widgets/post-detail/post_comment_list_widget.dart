import 'package:comment_tree/comment_tree.dart';
import 'package:vdiary_internship/data/models/post/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/store/post_store.dart';

import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/shared/widgets/stack_reaction/stack_reaction_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../../controllers/post_controller.dart';

class PostDetailCommentList extends StatefulWidget {
  const PostDetailCommentList({super.key, this.post});

  final PostModel? post;

  @override
  State<PostDetailCommentList> createState() => _PostDetailCommentListState();
}

class _PostDetailCommentListState extends State<PostDetailCommentList> {
  // Helper xác định quyền sửa/xóa
  bool isAuthor(String? commentAuthorId, String? currentUserId) {
    return commentAuthorId != null && commentAuthorId == currentUserId;
  }

  // ignore: unused_field
  late final PostController _postController;
  bool _isControllerInitialized = false;

  @override
  void didUpdateWidget(PostDetailCommentList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post?.id != widget.post?.id) {
      _loadCommentsForCurrentPost();
    }
  }

  Future<void> _loadCommentsForCurrentPost() async {
    if (widget.post?.id != null) {
      debugPrint('Loading comments for post: ${widget.post!.id}');

      // Clear comments cũ
      context.postStore.clearListComments();

      // Load comments mới
      await context.postStore.loadListCommentByPost(widget.post!.id);

      debugPrint('Finished loading comments for post: ${widget.post!.id}');
    }
  }

  void _handleReplyComment(
    PostStore postStore,
    String? userName,
    String? commentId,
  ) {
    debugPrint('TRONG POST COMMENT LIST: $commentId');
    postStore.setReplyInputValue(userName ?? '');
    postStore.setCommentHaveReplyValue();
    if (postStore.parentCommentId.isEmpty) {
      debugPrint('Ở ĐÂY');
      postStore.setParentCommentId(commentId!);
    }
  }

  @override
  void didChangeDependencies() {
    // Chỉ khởi tạo controller một lần
    if (!_isControllerInitialized && widget.post != null) {
      _postController = PostController(postStoreRef: context.postStore);
      _isControllerInitialized = true;

      context.friendStore.loadFriends();

      _loadCommentsForCurrentPost();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // HEADER: Like reactions + Most relevant
        PaddingLayout.symmetric(
          horizontal: 22,
          child: Column(
            children: [
              HSpacing(20),
              Observer(
                builder: (_) {
                  final postStore = context.postStore;
                  final postLikeNumber =
                      postStore.listLikeUsers[widget.post!.id];
                  return Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: StackReactionWidget(likeModels: postLikeNumber),
                      ),
                      WSpacing(5),
                      GestureDetector(
                        onTap:
                            () => _postController.openPostReactionBottomSheet(
                              context,
                              widget.post?.id ?? '',
                            ),
                        child: Text(
                          '${postLikeNumber?.length ?? 0} reactions',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              HSpacing(10),
              Row(
                children: [
                  Text(
                    'Most revelant',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColor.defaultColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: AppColor.defaultColor),
                ],
              ),
              HSpacing(25),
            ],
          ),
        ),

        // LIST COMMENT TREE
        Observer(
          builder: (_) {
            final postStore = context.postStore;
            final allComments = postStore.listComments;
            if (allComments.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Lottie.asset(ImagePath.lottieFriend),
                ),
              );
            }
            // Build tree, but for each parent, fetch child from mapCommentWithChildComments
            final rootComments = buildCommentTree(allComments);
            return PaddingLayout.symmetric(
              horizontal: 22,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                itemCount: rootComments.length,
                itemBuilder: (context, index) {
                  final root = rootComments[index];
                  // Lấy child comment từ map nếu có
                  final childComments =
                      postStore.mapCommentWithChildComments[root.id] ??
                      root.replies ??
                      [];
                  return CommentTreeWidget<Comment, Comment>(
                    mapToComment(root),
                    childComments.map((r) => mapToComment(r)).toList(),
                    treeThemeData: TreeThemeData(
                      lineColor: AppColor.lightGrey,
                      lineWidth: 1,
                    ),
                    avatarRoot:
                        (context, data) => PreferredSize(
                          preferredSize: const Size.fromRadius(18),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                (data.avatar ?? '').isNotEmpty
                                    ? NetworkImage(data.avatar ?? '')
                                    : null,
                            backgroundColor: Colors.grey[300],
                            child:
                                (data.avatar ?? '').isEmpty
                                    ? Icon(Icons.person)
                                    : null,
                          ),
                        ),
                    avatarChild:
                        (context, data) => PreferredSize(
                          preferredSize: const Size.fromRadius(12),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage:
                                (data.avatar ?? '').isNotEmpty
                                    ? NetworkImage(data.avatar ?? '')
                                    : null,
                            backgroundColor: Colors.grey[200],
                            child:
                                (data.avatar ?? '').isEmpty
                                    ? Icon(Icons.person, size: 12)
                                    : null,
                          ),
                        ),
                    contentRoot: (context, data) {
                      final postStore = context.postStore;
                      final authStore = context.authStore;
                      final commentId = (data as CustomComment).id;
                      // Nếu cần lấy thêm các trường khác, có thể truyền vào CustomComment
                      final commentModel = postStore.listComments.firstWhere(
                        (c) => c.id == commentId,
                        orElse: () => CommentModel(),
                      );
                      final createPostTime = commentModel.createdAt;
                      final commentAuthorId = commentModel.author?.id;
                      final currentUserId = authStore.userInfo?['_id'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.userName ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                HSpacing(4),
                                Text(
                                  data.content ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DefaultTextStyle(
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                            child: PaddingLayout.only(
                              left: 5,
                              child: Row(
                                children: [
                                  Text(formatTimeAgo(createPostTime)),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      if (commentId != null) {
                                        // TODO: Gọi action like comment
                                      }
                                    },
                                    child: Text('Like'),
                                  ),
                                  SizedBox(width: 15),
                                  GestureDetector(
                                    onTap:
                                        () => _handleReplyComment(
                                          postStore,
                                          data.userName,
                                          commentId,
                                        ),
                                    child: Text('Reply'),
                                  ),
                                  isAuthor(commentAuthorId, currentUserId)
                                      ? PopupMenuButton<String>(
                                        popUpAnimationStyle: AnimationStyle(
                                          curve: Curves.bounceInOut,
                                        ),
                                        position: PopupMenuPosition.under,
                                        padding: EdgeInsets.zero,
                                        offset: Offset(20, -10),
                                        icon: SvgPicture.asset(
                                          ImagePath.menuBlackIcon,
                                          width: 20,
                                          height: 20,
                                        ),
                                        itemBuilder:
                                            (
                                              BuildContext context,
                                            ) => <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                key: ValueKey(
                                                  'popup_${commentId ?? index}',
                                                ),
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
                                                      style:
                                                          context
                                                              .textTheme
                                                              .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuDivider(),
                                              PopupMenuItem<String>(
                                                key: ValueKey(
                                                  'popup_${commentId ?? index}',
                                                ),
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
                                                      style:
                                                          context
                                                              .textTheme
                                                              .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'edit':
                                              // TODO: Gọi action edit comment
                                              break;
                                            case 'delete':
                                              if (commentId != null) {
                                                _postController
                                                    .showDeleteCommentConfirmDialog(
                                                      context,
                                                      commentId,
                                                    );
                                              }
                                              break;
                                          }
                                        },
                                      )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    contentChild: (context, data) {
                      final postStore = context.postStore;
                      final authStore = context.authStore;
                      final commentId = (data as CustomComment).id;
                      final commentModel = postStore.listComments.firstWhere(
                        (c) => c.id == commentId,
                        orElse: () => CommentModel(),
                      );
                      final createTimeComment = commentModel.createdAt;
                      final commentAuthorId = commentModel.author?.id;
                      final currentUserId = authStore.userInfo?['_id'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.userName ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                HSpacing(4),
                                Text(
                                  data.content ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DefaultTextStyle(
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall!.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                            child: PaddingLayout.only(
                              left: 5,
                              child: Row(
                                children: [
                                  Text(
                                    formatTimeAgo(createTimeComment),
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  WSpacing(10),
                                  GestureDetector(
                                    onTap: () {
                                      if (commentId != null) {
                                        postStore.toggleLike(commentId, 'like');
                                      }
                                    },
                                    child: Text('Like'),
                                  ),
                                  WSpacing(10),
                                  GestureDetector(
                                    onTap:
                                        () => _handleReplyComment(
                                          postStore,
                                          data.userName,
                                          commentId,
                                        ),
                                    child: Text('Reply'),
                                  ),
                                  isAuthor(commentAuthorId, currentUserId)
                                      ? PopupMenuButton<String>(
                                        popUpAnimationStyle: AnimationStyle(
                                          curve: Curves.bounceInOut,
                                        ),
                                        position: PopupMenuPosition.under,
                                        padding: EdgeInsets.zero,
                                        offset: Offset(20, -10),
                                        icon: SvgPicture.asset(
                                          ImagePath.menuBlackIcon,
                                          width: 20,
                                          height: 20,
                                        ),
                                        itemBuilder:
                                            (
                                              BuildContext context,
                                            ) => <PopupMenuEntry<String>>[
                                              PopupMenuItem<String>(
                                                key: ValueKey(
                                                  'popup_${commentId ?? index}',
                                                ),
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
                                                      style:
                                                          context
                                                              .textTheme
                                                              .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuDivider(),
                                              PopupMenuItem<String>(
                                                key: ValueKey(
                                                  'popup_${commentId ?? index}',
                                                ),
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
                                                      style:
                                                          context
                                                              .textTheme
                                                              .bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'edit':
                                              debugPrint(
                                                'Bạn đã chọn Chỉnh sửa',
                                              );
                                              break;
                                            case 'delete':
                                              if (commentId != null) {
                                                _postController
                                                    .showDeleteCommentConfirmDialog(
                                                      context,
                                                      commentId,
                                                    );
                                              }
                                              break;
                                          }
                                        },
                                      )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

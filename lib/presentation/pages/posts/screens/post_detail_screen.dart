import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/data/services/socket_service.dart';
import 'package:vdiary_internship/presentation/pages/posts/controllers/post_controller.dart';
import 'package:vdiary_internship/presentation/pages/posts/store/post_store.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post-detail/post_comment_list_widget.dart';
import 'package:vdiary_internship/presentation/pages/posts/widgets/post-detail/post_detail_content_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/appbar/appbar_userinfor_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post, this.postId});

  // Named constructor for dynamic links that only have postId
  const PostDetailScreen.fromId({super.key, required this.postId})
    : post = null;

  final PostModel? post;
  final String? postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool isSomeoneTyping = false;
  String typingUserName = '';
  String typingPostId = '';
  PostController? _postController;
  bool _isControllerInitialized = false;
  // ignore: unused_field
  bool _isInputFocused = false;
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FlutterMentionsState> _mentionsKey =
      GlobalKey<FlutterMentionsState>();

  @override
  void initState() {
    super.initState();
    debugPrint(
      'PostDetailScreen: initState called with postId: ${widget.postId}',
    );
    _focusNode.addListener(() {
      setState(() {
        _isInputFocused = _focusNode.hasFocus;
      });
    });
    listenTypingIndicator();

    // JOIN VÀO POST ID - handle both post object and postId
    final postIdToJoin = widget.post?.id ?? widget.postId;
    if (postIdToJoin != null) {
      debugPrint('PostDetailScreen: Joining post with ID: $postIdToJoin');
      SocketService().joinPost(postIdToJoin);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    debugPrint('PostDetailScreen: didChangeDependencies called');
    if (!_isControllerInitialized) {
      _postController = PostController(postStoreRef: context.postStore);
      debugPrint('PostDetailScreen: PostController initialized');

      // Handle both cases: existing post object or postId from dynamic link
      if (widget.post != null) {
        debugPrint(
          'PostDetailScreen: Loading post from widget.post with ID: ${widget.post!.id}',
        );
        // Gọi fetch ngay lập tức với post object
        _postController!.findNewfeedPostDetail(widget.post!.id);
      } else if (widget.postId != null) {
        debugPrint(
          'PostDetailScreen: Loading post from widget.postId: ${widget.postId}',
        );
        // Load post from postId (dynamic link case)
        _postController!.findNewfeedPostDetail(widget.postId!);
      } else {
        debugPrint('PostDetailScreen: No post or postId available');
      }

      _isControllerInitialized = true;
    }
    super.didChangeDependencies();
  }

  void emitTyping(String postId, String userId) {
    SocketService().emit('commentTyping', {'postId': postId, 'userId': userId});
  }

  void listenTypingIndicator() {
    SocketService().socket?.on('commentTyping', (data) async {
      final userId = data['userId'];
      final postId = data['postId'];
      final currentPostId = widget.post?.id ?? widget.postId;

      if (currentPostId == postId) {
        String userName = await _getUserNameById(userId);
        setState(() {
          isSomeoneTyping = true;
          typingUserName = userName;
          typingPostId = postId;
        });
        Future.delayed(Duration(seconds: 2), () {
          if (mounted && typingPostId == postId) {
            setState(() {
              isSomeoneTyping = false;
              typingUserName = '';
              typingPostId = '';
            });
          }
        });
      }
    });
  }

  Future<String> _getUserNameById(String userId) async {
    final friendStore = context.friendStore;
    final user = friendStore.friends.firstWhere(
      (f) => f.id == userId,
      orElse: () => UserModel(),
    );
    return user.name ?? 'Someone';
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        // Use existing post or wait for loaded post from store
        final currentPost = widget.post ?? context.postStore.postDetail;

        debugPrint('PostDetailScreen: Build - currentPost: ${currentPost?.id}');
        debugPrint('PostDetailScreen: Build - widget.post: ${widget.post?.id}');
        debugPrint(
          'PostDetailScreen: Build - store.postDetail: ${context.postStore.postDetail?.id}',
        );

        // Show loading if we don't have a post yet (dynamic link case)
        if (currentPost == null) {
          debugPrint('PostDetailScreen: Showing loading state');
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading Post...'),
              backgroundColor: AppColor.backgroundColor,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading post...'),
                ],
              ),
            ),
          );
        }

        debugPrint(
          'PostDetailScreen: Rendering post content for: ${currentPost.id}',
        );
        return _buildPostScaffold(currentPost);
      },
    );
  }

  Widget _buildPostScaffold(PostModel currentPost) {
    return Portal(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, kToolbarHeight),
          child: AppBarWithUserInforWidget(currentPost: currentPost),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: () async {
              final postIdToRefresh = currentPost.id;
              if (postIdToRefresh.isNotEmpty) {
                await _postController?.findNewfeedPostDetail(postIdToRefresh);
              }
            },
            child: _buildBody(_mentionsKey),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(GlobalKey key) {
    return Observer(
      builder: (_) {
        // Sử dụng post mới từ store nếu có, ngược lại dùng widget.post
        final postStore = context.postStore;
        final currentPost = widget.post ?? postStore.postDetail;

        // Return loading if no post available
        if (currentPost == null) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildPostContent(
          context,
          currentPost,
          postStore.isLoading,
          key,
        );
      },
    );
  }

  Widget _buildPostContent(
    BuildContext context,
    PostModel post,
    bool isLoading,
    GlobalKey key,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLoading && context.postStore.postDetail != null)
                  SizedBox(
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: AppColor.lightGrey.withValues(
                        alpha: 0.3,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.lightBlue,
                      ),
                    ),
                  ),
                PostDetailContentWidget(post: post),
                PostDetailCommentList(post: post),
              ],
            ),
          ),
        ),
        // INPUT COMMENT - Facebook style
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: AppColor.lightGrey.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Observer(
            builder: (_) {
              final authStore = context.authStore;
              final userInfo = authStore.userInfo;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User Avatar
                  Container(
                    margin: EdgeInsets.only(bottom: 8, right: 12, top: 8),
                    child: AvatarBoxShadowWidget(
                      width: 50,
                      height: 50,
                      imageUrl: userInfo!['avatar'],
                    ),
                  ),
                  // Input Field Container
                  Expanded(
                    child: Observer(
                      builder: (context) {
                        final userInfor = context.authStore.userInfo;
                        final postStore = context.postStore;
                        return Column(
                          children: [
                            PaddingLayout.only(
                              left: 2,
                              bottom: 5,
                              child: Row(
                                children: [
                                  postStore.replyToUser.isNotEmpty
                                      ? RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: postStore.replyToUser,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            TextSpan(text: ' - '),
                                          ],
                                          text: 'Replying to ',
                                          style: context.textTheme.bodySmall,
                                        ),
                                      )
                                      : SizedBox.shrink(),

                                  // CANCEL BUTTON
                                  postStore.replyToUser.isNotEmpty
                                      ? GestureDetector(
                                        onTap: () {
                                          postStore.setReplyInputValue('');
                                          postStore.setCommentInputValue('');
                                          postStore.setCommentHaveReplyValue();
                                          postStore.setParentCommentId('');
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.mediumGrey,
                                              ),
                                        ),
                                      )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                            _buildCommentInput(
                              userInfor?['name'] ?? 'Unknown',
                              key,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Send Button
                  AnimatedSwitcher(
                    duration: const Duration(seconds: 2),
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },

                    child: Observer(
                      builder: (_) {
                        final postStore = context.postStore;
                        final commentInputValue = postStore.commentInput;
                        return postStore.commentInput.isNotEmpty
                            ? Container(
                              key: ValueKey<String>(
                                commentInputValue.isNotEmpty
                                    ? 'enabled'
                                    : 'disabled',
                              ),
                              margin: EdgeInsets.only(
                                left: 5,
                                top: postStore.replyToUser.isNotEmpty ? 20 : 0,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: () => _sendComment(postStore),
                                  child: Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color:
                                          commentInputValue.isNotEmpty
                                              ? AppColor.lightBlue
                                              : AppColor.lightGrey.withValues(
                                                alpha: 0.5,
                                              ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Send',
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  commentInputValue.isNotEmpty
                                                      ? AppColor.backgroundColor
                                                      : AppColor.defaultColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            : SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput(String userName, GlobalKey key) {
    return Observer(
      builder: (_) {
        final friendStore = context.friendStore;
        final postStore = context.postStore;
        List<Map<String, dynamic>> mentionData =
            friendStore.friends
                .map(
                  (friend) => {
                    'id': friend.id ?? 'Unknown',
                    'display': friend.name ?? 'Unknown',
                    'full_name': friend.name ?? 'Unknown',
                    'photo': friend.avatarUrl ?? '',
                  },
                )
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSomeoneTyping && typingUserName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
                child: Text(
                  '$typingUserName is typing...',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColor.lightBlue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            FlutterMentions(
              key: key,
              enableSuggestions: true,
              focusNode: _focusNode,
              suggestionPosition: SuggestionPosition.Top,
              maxLines: 5,
              minLines: 1,
              defaultText: postStore.commentInput,
              mentions: [
                Mention(
                  trigger: '@',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColor.lightBlue,
                    fontSize: 14,
                    height: 1.2,
                  ),
                  data: mentionData,
                  matchAll: true,
                  suggestionBuilder: (data) {
                    return Container(
                      padding: EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(data['photo']),
                          ),
                          WSpacing(20.0),
                          Column(
                            children: [
                              Text(data['id']),
                              Text('@${data['display']}'),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
              style: context.textTheme.bodySmall,
              decoration: _facebookStyleInputDecoration(userName),
              onChanged: (value) {
                debugPrint('VALUE TRONG MENTION: $value');
                postStore.setCommentInputValue(value);

                // Lấy mapping từ controller
                final tagMapping =
                    _mentionsKey.currentState?.controller?.mapping;

                // Lấy danh sách ID từ các values của mapping
                if (tagMapping != null) {
                  final List<String> mentionedUserIds =
                      tagMapping.values
                          .map((annotation) => annotation.id as String)
                          .toList();
                  debugPrint('Các ID đã trích xuất: $mentionedUserIds');
                }

                // Phát sự kiện đang nhập
                final authStore = context.authStore;
                final userId = authStore.userInfo?['id'] ?? '';
                if (widget.post?.id != null && userId.isNotEmpty) {
                  emitTyping(widget.post!.id, userId);
                }
              },
              onMentionAdd: (mention) {
                debugPrint('Mention added: ${mention['display']}');
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration _facebookStyleInputDecoration(String userName) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: AppColor.superLightGrey,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      hintText: 'Write a comment...',
      hintStyle: context.textTheme.bodySmall?.copyWith(
        color: AppColor.mediumGrey,
        letterSpacing: 1,
      ),
      border: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _sendComment(PostStore postStore) async {
    final commentText = postStore.commentInput.trim();
    final parentCommentId = postStore.parentCommentId;
    debugPrint('PARENT COMMENT ID TRONG DETAIL: $parentCommentId');
    if (commentText.isNotEmpty && widget.post?.id != null) {
      final success =
          postStore.replyToUser.isNotEmpty
              ? await _postController?.createChildComment(
                widget.post?.id ?? '',
                parentCommentId,
                commentText,
                context,
              )
              : await _postController?.createComment(
                widget.post!.id,
                commentText,
                context,
              );
      if (success == true) {
        postStore.resetCommentForm();
        _mentionsKey.currentState?.controller?.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    }
  }
}

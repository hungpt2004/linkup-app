import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdiary_internship/core/constants/secret_key.dart';
import 'package:vdiary_internship/data/services/google_check_safe_url_service.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';
import '../../../../core/constants/api/end_point.dart';
import '../../../../core/constants/gen/image_path.dart';
import '../../../../data/models/post/post_model.dart';
import '../../../../data/models/tab/share_action_model.dart';
import '../../create-posts/screens/create_post_screen.dart';
import '../store/post_store.dart';
import '../widgets/post_report_option_list_widget.dart';
import '../widgets/reaction_tabbarview_section.dart';
import '../services/post_sharing_service.dart';
import '../services/optimized_post_sharing_service.dart';
import '../../../routes/app_navigator.dart';
import '../../../shared/extensions/bottom_sheet_extension.dart';
import '../../../shared/extensions/dialog_extension.dart';
import '../../../shared/extensions/store_extension.dart';
import '../../../shared/widgets/button/my_button.dart';
import '../../../shared/widgets/images/avatar_build_widget.dart';
import '../../../shared/widgets/layout/padding_layout.dart';
import '../../../shared/widgets/toast_message/toast_widget.dart';
import '../../../themes/theme/app-color/app_color.dart';
import '../../../themes/theme/app_theme.dart';
import '../../../themes/theme/responsive/app_responsive_size.dart';
import '../../../themes/theme/responsive/app_space_size.dart';

class PostController {
  final PostStore postStoreRef;

  PostController({required this.postStoreRef});

  Future<void> likePost(
    String postId,
    String typeReact,
    BuildContext context,
  ) async {
    try {
      var success = await postStoreRef.toggleLike(postId, typeReact);
      if (success) {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showSuccessToast(context, 'Like post thành công');
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ToastAppWidget.showErrorToast(context, error.toString());
    }
  }

  Future<void> dislikePost(String postId, BuildContext context) async {
    try {
      var success = await postStoreRef.toggleDislike(postId);
      if (success) {
        ToastAppWidget.showSuccessToast(context, 'Dislike post thành công');
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ToastAppWidget.showErrorToast(context, error.toString());
    }
  }

  // Kiểm tra user đã react chưa
  bool hasUserReacted(String postId, String userId) {
    return postStoreRef.hasUserReacted(postId, userId);
  }

  // Lấy loại reaction của user với post
  String? getUserReactionType(String postId, String userId) {
    return postStoreRef.getUserReactionType(postId, userId);
  }

  // Show option tương tác bài viết
  void showPostReportOptionBottomSheet(BuildContext context) {
    context.showBottomSheet(
      backgroundColor: AppColor.backgroundColor,
      height: ResponsiveSizeApp(context).screenHeight * 0.6,
      borderRadius: 10,
      isBack: true,
      isScrollControlled: true,
      child: PostReportOptionList(),
      text: 'Post Options',
    );
  }

  // Mở trang edit ảnh
  void openEditImageBottomSheet(BuildContext context, int imageIndex) {
    context.showBottomSheet(
      isBack: false,
      child: Column(
        children: [
          // REMOVE BUTTON
          MyAppButtonWidget(
            onPressed:
                () async => {
                  context.createPostStore.removeImagePath(imageIndex),
                  AppNavigator.pop(context),
                },
            backgroundColor: AppColor.backgroundColor,
            child: Center(
              child: Text(
                'Remove photo',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.errorRed,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColor.lightGrey),
          // EDIT PHOTO
          MyAppButtonWidget(
            onPressed: () => {},
            backgroundColor: AppColor.backgroundColor,
            child: Center(
              child: Text(
                'Edit photo',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.lightBlue,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColor.lightGrey),
          // EDIT ALT TEXT
          MyAppButtonWidget(
            onPressed: () => {},
            backgroundColor: AppColor.backgroundColor,
            child: Center(
              child: Text(
                'Edit alt text',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.lightBlue,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColor.lightGrey),
          // CANCEL
          MyAppButtonWidget(
            onPressed: () => {},
            backgroundColor: AppColor.backgroundColor,
            child: Center(
              child: Text(
                'Cancel',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColor.lightGrey),
        ],
      ),
      text: '',
      height: ResponsiveSizeApp(context).screenHeight * 0.3,
    );
  }

  // BOTTOM SHEET FILTER POST
  void openFilterHomeBottomSheet(BuildContext context) {
    final postStore = context.postStore;
    context.showBottomSheet(
      text: '',
      isScrollControlled: true,
      isBack: false,
      height: ResponsiveSizeApp(context).screenHeight * 0.35,
      child: Observer(
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<bool>(
                value: true,
                groupValue: postStore.isPreviewLink,
                onChanged: (val) {
                  postStore.setIsPreviewLink(true);
                },
                title: Text('Show preview link'),
                subtitle: Text('Show link preview in post'),
              ),
              RadioListTile<bool>(
                value: false,
                groupValue: postStore.isPreviewLink,
                onChanged: (val) {
                  postStore.setIsPreviewLink(false);
                },
                title: Text('Show video demo'),
                subtitle: Text('Show video preview in post'),
              ),
              HSpacing(20),
              PaddingLayout.symmetric(
                horizontal: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => AppNavigator.pop(context),
                      child: Text('Done'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // BOTTOM SHEET SHARE POST
  void openShareOptionBottomSheet(BuildContext context) {
    context.showBottomSheet(
      height: ResponsiveSizeApp(context).screenHeight * 0.65,
      backgroundColor: AppColor.superLightGrey,
      isScrollControlled: true,
      child: Column(
        children: [
          PaddingLayout.symmetric(
            horizontal: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Your friends might get an invite from you to join the group.',
                    textAlign: TextAlign.start,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColor.mediumGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // HEADER
          PaddingLayout.all(
            value: 15,
            child: Container(
              width: ResponsiveSizeApp(context).screenWidth,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.backgroundColor,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      AvatarBoxShadowWidget(
                        imageUrl: ImagePath.avatarDefault,
                        width: 40,
                        height: 40,
                      ),
                      WSpacing(10),
                      SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pham Trong Hung'),
                            PaddingLayout.only(
                              left: 0,
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Feed',
                                            style: context.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: AppColor.defaultColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColor.defaultColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  WSpacing(10),
                                  Container(
                                    width: 110,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: AppColor.lightGrey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            ImagePath.lockBlackIcon,
                                            width: 12,
                                            height: 12,
                                          ),
                                          WSpacing(4),
                                          Text(
                                            'Only me',
                                            style: context.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: AppColor.defaultColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: AppColor.defaultColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      text: 'Choose options to share with',
    );
  }

  // ENHANCED SHARE POST WITH OPTIMIZED USER SELECTION
  void sharePostEnhanced(
    BuildContext context,
    PostModel post,
    List<ShareActionModel> listActions,
  ) {
    OptimizedPostSharingService.showEnhancedShareOptions(
      context: context,
      post: post,
      shareActionLists: listActions,
    );
  }

  // SHARE POST VIA DYNAMIC LINK
  Future<void> sharePostViaDynamicLink(
    BuildContext context,
    PostModel post,
  ) async {
    await PostSharingService.sharePost(
      context: context,
      post: post,
      shareType: ShareType.dynamicLink,
    );
  }

  // COPY POST LINK
  Future<void> copyPostLink(BuildContext context, PostModel post) async {
    await PostSharingService.sharePost(
      context: context,
      post: post,
      shareType: ShareType.copyLink,
    );
  }

  // HANDLE URL TAP WITH SAFE BROWSING CHECK
  Future<void> handleUrlTap(BuildContext context, String url) async {
    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Đảm bảo URL có đúng format (thêm http:// nếu cần)
      String formattedUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        formattedUrl = 'http://$url';
      }

      // Tạo SafeBrowsingService instance
      final safeBrowsingService = SafeBrowsingService(
        dio: Dio(),
        apiKey: SecretKey().googleApiKey, // Thay bằng API key thật
      );

      // Check URL safety
      final result = await safeBrowsingService.checkUrl(formattedUrl);

      // Đóng loading dialog
      Navigator.of(context).pop();

      if (result.isSafe) {
        // URL an toàn, mở trực tiếp
        final uri = Uri.parse(formattedUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        // URL nguy hiểm, hiển thị cảnh báo
        showUnsafeUrlDialog(context, formattedUrl, result);
      }
    } catch (e) {
      // Debug log lỗi
      debugPrint('❌ SafeBrowsing API Error: $e');

      // Đóng loading dialog nếu có lỗi
      Navigator.of(context).pop();

      // Nếu lỗi API, vẫn cho phép mở URL với cảnh báo
      showUrlErrorDialog(context, url, e.toString());
    }
  }

  // UNSAFE URL DIALOG
  void showUnsafeUrlDialog(
    BuildContext context,
    String url,
    SafeBrowsingResult result,
  ) {
    context.showCustomDialog(
      title: '⚠️ Cảnh báo bảo mật',
      subtitle: 'URL này có thể không an toàn',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            url,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          HSpacing(12),
          const Text('Các mối đe dọa được phát hiện:'),
          ...result.matches.map(
            (match) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text('• ${match.threatType}'),
            ),
          ),
          HSpacing(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              WSpacing(8),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Vẫn mở'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // URL ERROR DIALOG
  void showUrlErrorDialog(BuildContext context, String url, [String? error]) {
    context.showCustomDialog(
      title: 'Không thể kiểm tra URL',
      subtitle:
          'Không thể xác minh tính bảo mật của URL này. Bạn có muốn tiếp tục?',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error != null) ...[
            const Text(
              'Chi tiết lỗi:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              error,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            HSpacing(16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Hủy'),
              ),
              WSpacing(8),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Text('Mở URL'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // BOTTOM SHEET VIEW REACTION
  void openPostReactionBottomSheet(BuildContext context, String postId) {
    // ignore: non_constant_identifier_names
    final double WIDTH = 20;
    // ignore: non_constant_identifier_names
    final double HEIGHT = 20;
    context.showBottomSheet(
      child: DefaultTabController(
        length: 7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TabBar(
              labelColor: Colors.blue,
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
                color: AppColor.lightGrey,
              ),
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                color: AppColor.defaultColor,
              ),
              indicatorColor: Colors.blue,
              automaticIndicatorColorAdjustment: true,
              tabs: [
                Tab(text: "All"),
                Tab(
                  icon: SizedBox(
                    width: WIDTH,
                    height: HEIGHT,
                    child: ClipRRect(
                      child: SvgPicture.asset(ImagePath.likeReactionSVG),
                    ),
                  ),
                ),
                Tab(
                  icon: SizedBox(
                    width: WIDTH,
                    height: HEIGHT,
                    child: ClipRRect(
                      child: SvgPicture.asset(ImagePath.loveReactionSVG),
                    ),
                  ),
                ),
                Tab(
                  icon: SizedBox(
                    width: WIDTH,
                    height: HEIGHT,
                    child: ClipRRect(
                      child: SvgPicture.asset(ImagePath.careReactionSVG),
                    ),
                  ),
                ),
                Tab(
                  icon: SizedBox(
                    width: WIDTH,
                    height: HEIGHT,
                    child: ClipRRect(
                      child: SvgPicture.asset(ImagePath.hahaReactionSVG),
                    ),
                  ),
                ),
                Tab(
                  icon: SizedBox(
                    width: WIDTH,
                    height: HEIGHT,
                    child: ClipRRect(
                      child: SvgPicture.asset(ImagePath.sadReactionSVG),
                    ),
                  ),
                ),
                Tab(
                  icon: SizedBox(
                    width: WIDTH,
                    height: HEIGHT,
                    child: ClipRRect(
                      child: SvgPicture.asset(ImagePath.angryReactionSVG),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ReactionTabViewSection(postId: postId, typeReaction: ''),
                  ReactionTabViewSection(
                    postId: postId,
                    typeReaction: TypeReaction.like.name,
                  ),
                  ReactionTabViewSection(
                    postId: postId,
                    typeReaction: TypeReaction.love.name,
                  ),
                  ReactionTabViewSection(
                    postId: postId,
                    typeReaction: TypeReaction.care.name,
                  ),
                  ReactionTabViewSection(
                    postId: postId,
                    typeReaction: TypeReaction.haha.name,
                  ),
                  ReactionTabViewSection(
                    postId: postId,
                    typeReaction: TypeReaction.sad.name,
                  ),
                  ReactionTabViewSection(
                    postId: postId,
                    typeReaction: TypeReaction.angry.name,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      height: ResponsiveSizeApp(context).screenHeight * 0.4,
      isBack: false,
      isScrollControlled: true,
      text: '',
    );
  }

  // POST DETAIL
  Future<void> findNewfeedPostDetail(String id) async {
    try {
      bool success = await postStoreRef.loadPostDetailSilently(id);
      if (success) {
        debugPrint('Trạng thái API lấy post detail: $success');
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // FIND REACTION BY TYPE
  Future<void> findReactionByType(String postId, String typeReact) async {
    await postStoreRef.getReactionByTypeReact(postId, typeReact);
  }

  // TẠO COMMENT PARENT
  Future<bool> createComment(
    String postId,
    String commentText,
    BuildContext context,
  ) async {
    try {
      final success = await postStoreRef.createNewComment(postId, commentText);
      if (success) {
        // ignore: use_build_context_synchronously

        final userInfor = context.authStore.userInfo;
        final currentUserId = userInfor?['_id'] ?? '';
        final currentUserName = userInfor?['email'] ?? '';
        final currentAvatar = userInfor?['avatar'] ?? '';
        final currentFullname = userInfor?['name'] ?? '';
        final userEntity = UserEntity(
          id: currentUserId,
          username: currentUserName,
          avatar: currentAvatar,
          fullname: currentFullname,
        );

        // TODO: hiện notification comment
        context.notificationStore.createNotification(
          authorInformation: userEntity,
          referenceId: postId, // Lưu post id để kiểm tra
          friends: context.friendStore.friends,
          actionAuthorId: currentUserId,
          contentNotification:
              '${userEntity.fullname} bình luận bài đăng của bạn',
          typeNotification: TypeNotification.comment.name,
          deepLink: 'socialapp/post/dashboard/',
        );

        ToastAppWidget.showSuccessToast(context, 'Comment sent successfully');
        return true;
      } else {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showErrorToast(context, 'Failed to send comment');
        return false;
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ToastAppWidget.showErrorToast(context, 'Error: ${error.toString()}');
      return false;
    }
  }

  // TẠO COMMENT CON
  Future<bool> createChildComment(
    String postId,
    String parentId,
    String commentText,
    BuildContext context,
  ) async {
    try {
      final success = await postStoreRef.createChildComment(
        postId,
        parentId,
        commentText,
      );
      if (success) {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showSuccessToast(context, 'Comment sent successfully');
        return true;
      } else {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showErrorToast(context, 'Failed to send comment');
        return false;
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ToastAppWidget.showErrorToast(context, 'Error: ${error.toString()}');
      return false;
    }
  }

  // EDIT POST
  Future<bool> updatePost(
    String postId,
    Map<String, dynamic> postData,
    BuildContext context,
  ) async {
    try {
      final success = await postStoreRef.updatePost(postId, postData);
      if (success) {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showSuccessToast(context, 'Post updated successfully');
        return true;
      } else {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showErrorToast(context, 'Failed to update post');
        return false;
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ToastAppWidget.showErrorToast(context, 'Error: ${error.toString()}');
      return false;
    }
  }

  // Kiểm tra user có quyền chỉnh sửa/xóa post không
  bool canEditPost(String postAuthorId, String currentUserId) {
    return postAuthorId == currentUserId;
  }

  bool canEditComment(String commentAuthorId, String currentUserId) {
    return commentAuthorId == currentUserId;
  }

  bool canReply(String authorName, String currentUserName) {
    if (authorName == currentUserName) return true;
    return false;
  }

  // CONFIRM EDIT POST
  void showPostOwnerOptions(
    BuildContext context,
    String postId, [
    PostModel? post,
  ]) {
    context.showBottomSheet(
      backgroundColor: AppColor.backgroundColor,
      height: ResponsiveSizeApp(context).screenHeight * 0.25,
      borderRadius: 10,
      isBack: true,
      child: Column(
        children: [
          // EDIT POST
          MyAppButtonWidget(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to edit post screen
              if (post != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CreatePostScreen(editPost: post, isEditMode: true),
                  ),
                );
              } else {
                debugPrint('Post object is null for edit: $postId');
              }
            },
            backgroundColor: AppColor.backgroundColor,
            child: Center(
              child: Text(
                'Edit Post',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColor.lightGrey),

          // DELETE POST
          MyAppButtonWidget(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmDialog(context, postId);
            },
            backgroundColor: AppColor.backgroundColor,
            child: Center(
              child: Text(
                'Delete Post',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.errorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(height: 1, color: AppColor.lightGrey),

          // CANCEL
          MyAppButtonWidget(
            onPressed: () => Navigator.pop(context),
            backgroundColor: AppColor.backgroundColor,
            child: Center(
              child: Text(
                'Cancel',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColor.mediumGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      text: 'Post Options',
    );
  }

  // CONFIRMT DLETE POST
  void _showDeleteConfirmDialog(BuildContext context, String postId) {
    context.showCustomDialog(
      title: 'Delete Post',
      subtitle:
          'Are you sure you want to delete this post? This action cannot be undone.',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePost(postId, context);
            },
            child: Text('Delete', style: TextStyle(color: AppColor.errorRed)),
          ),
        ],
      ),
    );
  }

  // CONFIRM DELETE COMMENT
  void showDeleteCommentConfirmDialog(BuildContext context, String postId) {
    context.showCustomDialog(
      barrierDismissible: true,
      showCloseButton: false,
      title: 'Delete Post',
      subtitle:
          'Are you sure you want to delete this comment? This action cannot be undone.',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColor.lightBlue),
            ),
            onPressed: () => AppNavigator.pop(context),
            child: Text(
              'Cancel',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColor.backgroundColor,
              ),
            ),
          ),
          WSpacing(10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColor.errorRed),
            ),
            onPressed: () {
              Navigator.pop(context);
              deleteComment(postId);
            },
            child: Text(
              'Delete',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColor.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // XÓA COMMENT
  Future<void> deleteComment(String commentId) async {
    await postStoreRef.deleteComment(commentId);
  }

  // XÓA POST
  Future<void> _deletePost(String postId, BuildContext context) async {
    try {
      final success = await postStoreRef.deletePost(postId);
      if (success) {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showSuccessToast(context, 'Post deleted successfully');
        // Navigate back to dashboard after successful delete
        Navigator.of(
          // ignore: use_build_context_synchronously
          context,
        ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
      } else {
        // ignore: use_build_context_synchronously
        ToastAppWidget.showErrorToast(context, 'Failed to delete post');
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ToastAppWidget.showErrorToast(context, 'Error: ${error.toString()}');
    }
  }
}

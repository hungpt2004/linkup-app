import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
// Đảm bảo đường dẫn này chính xác
import 'package:vdiary_internship/core/constants/mock/mock_data.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/data/models/tab/share_action_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/services/post_sharing_service.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../controllers/post_controller.dart';

class PostActionsWidget extends StatefulWidget {
  const PostActionsWidget({super.key, required this.postId, this.post});

  final String postId;
  final PostModel? post;

  @override
  State<PostActionsWidget> createState() => _PostActionsWidgetState();
}

class _PostActionsWidgetState extends State<PostActionsWidget> {
  String? _currentReaction;
  late final PostController postController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeReaction();
    });
  }

  @override
  void didChangeDependencies() {
    postController = PostController(postStoreRef: context.postStore);
    super.didChangeDependencies();
  }

  void _initializeReaction() {
    if (!mounted) return;
    final postController = PostController(postStoreRef: context.postStore);
    final currentUserId = context.authStore.userInfo?['_id'];
    if (currentUserId != null) {
      final reactionType = postController.getUserReactionType(
        widget.postId,
        currentUserId,
      );
      if (mounted) {
        setState(() {
          _currentReaction = reactionType;
        });
      }
    }
  }

  void _handleShareOptionAction({
    required BuildContext context,
    required PostModel post,
    required ShareType shareType,
  }) {
    debugPrint(post.caption);
    if (widget.post != null) {
      PostSharingService.sharePost(
        context: context,
        post: post,
        shareType: shareType,
      );
    }
  }

  // Data tab share actions
  List<ShareActionModel> get shareActionLists {
    return [
      ShareActionModel.withDefaultFunction(
        title: 'Link',
        icon: ImagePath.linkIcon,
        function:
            () => {
              _handleShareOptionAction(
                context: context,
                post: widget.post!,
                shareType: ShareType.copyLink,
              ),
            },
      ),
      ShareActionModel.withDefaultFunction(
        title: 'Web View',
        icon: ImagePath.shareToIcon,
        function:
            () => {
              _handleShareOptionAction(
                context: context,
                post: widget.post!,
                shareType: ShareType.copyWebLink,
              ),
            },
      ),
      ShareActionModel.withDefaultFunction(
        title: 'Share via apps',
        icon: ImagePath.webIcon,
        function:
            () => {
              _handleShareOptionAction(
                context: context,
                post: widget.post!,
                shareType: ShareType.nativeShare,
              ),
            },
      ),
      ShareActionModel.withDefaultFunction(
        title: 'Messages',
        icon: ImagePath.messageIcon,
        function:
            () => {
              _handleShareOptionAction(
                context: context,
                post: widget.post!,
                shareType: ShareType.dynamicLink,
              ),
            },
      ),
      ShareActionModel.withDefaultFunction(
        title: 'Open in browser',
        icon: ImagePath.browserIcon,
        function: () {
          _handleShareOptionAction(
            context: context,
            post: widget.post!,
            shareType: ShareType.webLink,
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final postController = PostController(postStoreRef: context.postStore);
    return PaddingLayout.symmetric(
      horizontal: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLoveButton(postController),
          _buildButtonActionPost(
            'Comment',
            FluentIcons.chat_empty_16_regular,
            () => {},
          ),
          _buildButtonActionPost(
            'Share',
            FluentIcons.share_16_regular,
            () => _showShareBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLoveButton(PostController postController) {
    final Reaction<String> defaultReaction = Reaction<String>(
      value: 'default',
      icon: Icon(FluentIcons.thumb_like_28_regular, color: AppColor.mediumGrey),
      title: const Text('Like'),
    );

    final Reaction<String> displayedReaction =
        _currentReaction != null
            ? MockData.reactions.firstWhere(
              (reaction) => reaction.value == _currentReaction,
              orElse: () => defaultReaction,
            )
            : defaultReaction;

    return ReactionButton<String>(
      onReactionChanged: (reaction) async {
        if (!mounted) return;
        setState(() {
          _currentReaction = reaction?.value;
        });
        if (reaction == null || reaction.value == 'default') {
          await postController.dislikePost(widget.postId, context);
        } else {
          await postController.likePost(
            widget.postId,
            reaction.value!,
            context,
          );
        }
      },
      reactions: MockData.reactions,
      itemAnimationDuration: const Duration(milliseconds: 200),
      animateBox: true,
      boxAnimationDuration: const Duration(milliseconds: 200),
      selectedReaction: displayedReaction,
      toggle: true,
      boxPadding: const EdgeInsets.all(5),
      boxElevation: 10,
      itemScale: 0.5,
      isChecked: _currentReaction != null,
      itemSize: const Size(30, 30),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: _buildButtonContent(
          displayedReaction.icon,
          (displayedReaction.title! as Text).data!,
          // Sử dụng Key để AnimatedSwitcher biết khi nào widget thay đổi
          key: ValueKey<String>(displayedReaction.value ?? 'default'),
        ),
      ),
    );
  }

  Widget _buildButtonActionPost(
    String text,
    IconData icon,
    VoidCallback? function,
  ) {
    return SizedBox(
      child: GestureDetector(
        onTap: function,
        child: Row(
          children: [
            Icon(icon, color: AppColor.mediumGrey),
            WSpacing(2),
            Text(text, style: const TextStyle(color: AppColor.mediumGrey)),
          ],
        ),
      ),
    );
  }

  // Cập nhật _buildButtonContent để nhận key, giúp AnimatedSwitcher hoạt động
  Widget _buildButtonContent(Widget icon, String text, {Key? key}) {
    return Row(
      key: key,
      children: [
        icon,
        WSpacing(3),
        Text(
          text,
          style: const TextStyle(
            color: AppColor.mediumGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Show share options bottom sheet
  void _showShareBottomSheet(BuildContext context) {
    // Get the post object from the store if not provided
    final PostModel? currentPost =
        widget.post ??
        context.postStore.posts.where((p) => p.id == widget.postId).firstOrNull;

    if (currentPost == null) {
      // If post not found, show simple sharing options
      _showSimpleShareOptions(context);
      return;
    }

    // Use the enhanced sharing service with optimized user selection
    final postController = PostController(postStoreRef: context.postStore);
    postController.sharePostEnhanced(context, currentPost, shareActionLists);
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColor.lightBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColor.lightBlue, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      onTap: onTap,
    );
  }

  // Fallback simple share options if post object not available
  void _showSimpleShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                'Share Post',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              // Share options
              _buildShareOption(
                context,
                icon: FluentIcons.link_24_regular,
                title: 'Copy Link',
                subtitle: 'Copy post link to clipboard',
                onTap: () {
                  Navigator.pop(context);
                  _copyPostLink(context);
                },
              ),

              _buildShareOption(
                context,
                icon: FluentIcons.share_24_regular,
                title: 'Share via Apps',
                subtitle: 'Share using other apps',
                onTap: () {
                  Navigator.pop(context);
                  _shareNatively(context);
                },
              ),

              _buildShareOption(
                context,
                icon: FluentIcons.open_24_regular,
                title: 'Open in Browser',
                subtitle: 'View post in web browser',
                onTap: () {
                  Navigator.pop(context);
                  _openInBrowser(context);
                },
              ),

              const SizedBox(height: 10),

              // Cancel button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fallback methods when post object is not available
  void _copyPostLink(BuildContext context) async {
    // Create a simple web URL using custom domain
    final String webUrl =
        'https://idea-startup-client-private.vercel.app/post/${widget.postId}';

    // Copy to clipboard and show feedback
    await Clipboard.setData(ClipboardData(text: webUrl));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareNatively(BuildContext context) async {
    // Create share text with custom domain
    final String shareText =
        'Check out this post: https://idea-startup-client-private.vercel.app/post/${widget.postId}';

    // Use share_plus
    try {
      await Share.share(shareText);
    } catch (e) {
      // Fallback: copy to clipboard
      if (mounted) {
        _copyPostLink(context);
      }
    }
  }

  void _openInBrowser(BuildContext context) async {
    // Open web URL in browser with custom domain
    final String webUrl =
        'https://idea-startup-client-private.vercel.app/post/${widget.postId}';

    try {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      // Fallback: copy link
      if (mounted) {
        _copyPostLink(context);
      }
    }
  }
}

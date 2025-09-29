import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/pages/posts/services/real_dynamic_links_service.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';

class PostSharingService {
  // Share post via dynamic link
  static Future<void> sharePost({
    required BuildContext context,
    required PostModel post,
    ShareType shareType = ShareType.dynamicLink,
  }) async {
    try {
      switch (shareType) {
        case ShareType.dynamicLink:
          await _shareViaDynamicLink(context, post);
          break;
        case ShareType.copyLink:
          await _copyLinkToClipboard(context, post);
          break;
        case ShareType.copyWebLink:
          await _copyWebLinkToClipboard(context, post);
          break;
        case ShareType.nativeShare:
          await _shareViaNativeShare(context, post);
          break;
        case ShareType.webLink:
          await _openInWebBrowser(context, post);
          break;
      }
    } catch (e) {
      debugPrint('Error sharing post: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to share post');
      }
    }
  }

  // Share via Firebase Dynamic Link
  static Future<void> _shareViaDynamicLink(
    BuildContext context,
    PostModel post,
  ) async {
    try {
      // Show loading
      if (context.mounted) {
        ToastAppWidget.showSuccessToast(context, 'Generating share link...');
      }

      final String? shareLink =
          await RealDynamicLinksService.createPostShareLink(
            postId: post.id,
            postTitle: _getPostTitle(post),
            postDescription: _getPostDescription(post),
            imageUrl: post.images.isNotEmpty ? post.images.first : null,
          );

      if (shareLink != null) {
        // Ensure the share link text is within reasonable limits
        String shareContent = shareLink;
        if (post.caption.isNotEmpty) {
          // Add caption as context, but keep it short
          String caption = post.caption;
          if (caption.length > 500) {
            caption = '${caption.substring(0, 497)}...';
          }
          shareContent = '$caption\n\n$shareLink';
        }

        await Share.share(shareContent, subject: _getPostTitle(post));

        if (context.mounted) {
          ToastAppWidget.showSuccessToast(context, 'Post shared successfully!');
        }
      } else {
        throw Exception('Failed to generate share link');
      }
    } catch (e) {
      debugPrint('Error sharing via dynamic link: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to generate share link');
      }
    }
  }

  // Copy link to clipboard
  static Future<void> _copyLinkToClipboard(
    BuildContext context,
    PostModel post,
  ) async {
    try {
      // Generate web URL for direct link
      final String webUrl = 'socialapp://post/post-detail/${post.id}';

      await Clipboard.setData(ClipboardData(text: webUrl));

      debugPrint('Đã lưu link thành công vào clipboard');

      if (context.mounted) {
        ToastAppWidget.showSuccessToast(context, 'Link copied to clipboard!');
      }
    } catch (e) {
      debugPrint('Error copying link: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to copy link');
      }
    }
  }

  // Copy web link to clipboard (for sharing with users who don't have the app)
  static Future<void> _copyWebLinkToClipboard(
    BuildContext context,
    PostModel post,
  ) async {
    try {
      final String? shareLink =
          await RealDynamicLinksService.createPostShareLink(
            postId: post.id,
            postTitle: _getPostTitle(post),
            postDescription: _getPostDescription(post),
            imageUrl: post.images.isNotEmpty ? post.images.first : null,
          );

      if (shareLink != null) {
        await Clipboard.setData(ClipboardData(text: shareLink));

        if (context.mounted) {
          ToastAppWidget.showSuccessToast(
            context,
            'Web link copied to clipboard!',
          );
        }
      } else {
        throw Exception('Failed to generate link');
      }
    } catch (e) {
      debugPrint('Error copying web link: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to copy link');
      }
    }
  }

  // Share via native sharing
  static Future<void> _shareViaNativeShare(
    BuildContext context,
    PostModel post,
  ) async {
    try {
      // Create a meaningful share text without duplication and within Facebook limits
      String shareText =
          post.caption.isNotEmpty
              ? post.caption
              : 'Check out this post from VDiary!';

      // Process the text to handle URLs properly for social media sharing
      shareText = _formatShareTextForSocialMedia(shareText);

      if (post.images.isNotEmpty) {
        // Share with image
        await Share.share(shareText, subject: 'Shared from VDiary');
      } else {
        // Share text only
        await Share.share(shareText, subject: 'Shared from VDiary');
      }

      if (context.mounted) {
        ToastAppWidget.showSuccessToast(context, 'Post shared!');
      }
    } catch (e) {
      debugPrint('Error native sharing: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to share post');
      }
    }
  }

  // Helper method to format share text for social media platforms like Facebook
  static String _formatShareTextForSocialMedia(String text) {
    // Facebook and other social platforms have issues with very long URLs
    // This regex finds URLs in the text
    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    );

    // Replace long URLs with shorter placeholders to avoid length issues
    String formattedText = text;
    final matches = urlRegex.allMatches(text);

    // Process URLs from end to start to maintain correct indices
    for (final match in matches.toList().reversed) {
      final url = match.group(0) ?? '';
      // If URL is very long, replace it with a shorter placeholder
      if (url.length > 100) {
        final shortenedUrl =
            url.length > 30 ? '${url.substring(0, 30)}...' : url;
        formattedText = formattedText.replaceRange(
          match.start,
          match.end,
          shortenedUrl,
        );
      }
    }

    // Ensure overall text is within reasonable limits for social media sharing
    // Facebook has a limit of around 5000 characters, but we'll use a safer 2000
    const int maxTextLength = 2000;
    if (formattedText.length > maxTextLength) {
      formattedText = '${formattedText.substring(0, maxTextLength - 3)}...';
    }

    return formattedText;
  }

  // Open in web browser
  static Future<void> _openInWebBrowser(
    BuildContext context,
    PostModel post,
  ) async {
    try {
      await RealDynamicLinksService.openInBrowser(postId: post.id);

      if (context.mounted) {
        ToastAppWidget.showSuccessToast(context, 'Opening in browser...');
      }
    } catch (e) {
      debugPrint('Error opening in browser: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to open in browser');
      }
    }
  }

  // Share user profile
  static Future<void> shareUserProfile({
    required BuildContext context,
    required String userId,
    required String userName,
    String? userAvatarUrl,
  }) async {
    try {
      final String? shareLink =
          await RealDynamicLinksService.createUserProfileShareLink(
            userId: userId,
            userName: userName,
            userAvatarUrl: userAvatarUrl,
          );

      if (shareLink != null) {
        await Share.share(shareLink, subject: "${userName}'s Profile");

        if (context.mounted) {
          ToastAppWidget.showSuccessToast(
            context,
            'Profile shared successfully!',
          );
        }
      }
    } catch (e) {
      debugPrint('Error sharing user profile: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to share profile');
      }
    }
  }

  // Share chat room
  static Future<void> shareChatRoom({
    required BuildContext context,
    required String roomId,
    required String roomName,
    String? roomAvatarUrl,
  }) async {
    try {
      final String? shareLink =
          await RealDynamicLinksService.createChatRoomShareLink(
            roomId: roomId,
            roomName: roomName,
            roomAvatarUrl: roomAvatarUrl,
          );

      if (shareLink != null) {
        await Share.share(shareLink, subject: 'Join $roomName');

        if (context.mounted) {
          ToastAppWidget.showSuccessToast(
            context,
            'Chat room shared successfully!',
          );
        }
      }
    } catch (e) {
      debugPrint('Error sharing chat room: $e');
      if (context.mounted) {
        ToastAppWidget.showErrorToast(context, 'Failed to share chat room');
      }
    }
  }

  // Helper methods
  static String _getPostTitle(PostModel post) {
    String title = 'Check out this post!';

    if (post.caption.isNotEmpty) {
      title = post.caption;
    }

    // Ensure title is within reasonable limits for social media (typically 100-150 chars)
    if (title.length > 100) {
      title = '${title.substring(0, 97)}...';
    }

    return title;
  }

  static String _getPostDescription(PostModel post) {
    String description = 'Shared from our social app';

    if (post.caption.isNotEmpty) {
      description = post.caption;
    }

    // Ensure description is within reasonable limits for social media (typically 200-300 chars)
    if (description.length > 200) {
      description = '${description.substring(0, 197)}...';
    }

    return description;
  }

  // Analytics tracking
  static void trackPostShare({
    required String postId,
    required ShareType shareType,
  }) {
    try {
      RealDynamicLinksService.trackLinkOpen(
        linkType: shareType.toString(),
        contentId: postId,
      );
    } catch (e) {
      debugPrint('Error tracking post share: $e');
    }
  }
}

// Share type enum
enum ShareType { dynamicLink, copyLink, copyWebLink, nativeShare, webLink }

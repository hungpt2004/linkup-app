import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class OptionDialogScreen extends StatelessWidget {
  final String text;
  final int index;
  final bool isMe;
  final bool isDeleted;
  final String heroTag;
  final Offset? messagePosition;
  final String? senderId; // Add senderId
  final String? senderName; // Add senderName
  final String? messageId; // Add messageId

  const OptionDialogScreen({
    super.key,
    required this.text,
    required this.index,
    required this.isMe,
    required this.isDeleted,
    required this.heroTag,
    this.messagePosition,
    this.senderId,
    this.senderName,
    this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Use actual message position if available, otherwise fallback to center
    double messageTop = messagePosition?.dy ?? screenHeight * 0.4;

    // Calculate reaction bar position (above message)
    double reactionTop =
        messageTop - 60; // Calculate action menu position (below message)
    double actionTop = messageTop + 80;

    // Adjust positions to keep everything in viewport
    if (reactionTop < 50) {
      reactionTop = 50;
      messageTop = reactionTop + 60;
      actionTop = messageTop + 80;
    }

    if (actionTop + 200 > screenHeight) {
      actionTop = screenHeight - 220;
      messageTop = actionTop - 80;
      reactionTop = messageTop - 60;
    }

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: Stack(
        children: [
          // Background layer: catch taps outside to dismiss
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
          ),

          // Reaction bar positioned above message
          Positioned(
            top: reactionTop,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _reactionItem(context, "👍"),
                    _reactionItem(context, "❤️"),
                    _reactionItem(context, "😂"),
                    _reactionItem(context, "😮"),
                    _reactionItem(context, "😢"),
                    _reactionItem(context, "😡"),
                  ],
                ),
              ),
            ),
          ),

          // Hero message positioned at original message location
          Positioned(
            top: messageTop,
            left: isMe ? null : 16,
            right: isMe ? 16 : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
              child: Hero(
                tag: heroTag,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDeleted
                              ? Colors.transparent
                              : isMe
                              ? AppColor.lightBlue
                              : Colors.grey[200],
                      border:
                          isDeleted
                              ? Border.all(
                                color: AppColor.defaultColor,
                                width: 0.6,
                              )
                              : null,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow:
                          isDeleted
                              ? null
                              : [
                                const BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                ),
                              ],
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isDeleted
                                ? AppColor.defaultColor
                                : isMe
                                ? AppColor.backgroundColor
                                : AppColor.defaultColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Action menu positioned below message
          Positioned(
            top: actionTop,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: ResponsiveSizeApp(context).widthPercent(300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Observer(
                      builder: (_) {
                        final chatStore = context.chatStore;
                        return _actionTile(
                          context,
                          ImagePath.shareIcon,
                          "Reply",
                          () {
                            // Use the complete reply target data
                            if (messageId != null &&
                                senderId != null &&
                                senderName != null) {
                              chatStore.setReplyTarget(
                                messageId: messageId!,
                                userId: senderId!,
                                userName: senderName!,
                                messageText: text,
                              );
                            } else {
                              // Fallback to old method if data is missing
                              chatStore.setReplyingValue(text);
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                    _actionTile(context, ImagePath.copyIcon, "Copy", () {}),
                    isMe
                        ? _actionTile(
                          context,
                          ImagePath.removeIcon,
                          "Delete",
                          () {},
                        )
                        : _actionTile(
                          context,
                          ImagePath.translateIcon,
                          "Translate",
                          () {},
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reactionItem(BuildContext context, String emoji) {
    return InkWell(
      onTap: () {
        debugPrint("React $emoji on \"$text\"");
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context,
    String imagePath,
    String title,
    VoidCallback function,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Text(
        title,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: SvgPicture.asset(imagePath, width: 20, height: 20),
      onTap: () {
        debugPrint("$title action on \"$text\"");
        function(); // Execute the passed function
      },
    );
  }
}

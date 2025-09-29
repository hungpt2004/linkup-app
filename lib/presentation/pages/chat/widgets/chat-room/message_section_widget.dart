import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdiary_internship/data/models/message/message_model.dart';
import 'package:vdiary_internship/presentation/pages/chat/controller/chat_controller.dart';
import 'package:vdiary_internship/presentation/pages/chat/screens/option_dialog_screen.dart';
import 'message_item_widget.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

class MessageSectionWidget extends StatelessWidget {
  const MessageSectionWidget({
    super.key,
    required this.chatController,
    required this.message,
    required this.currentUserId,
    required this.currentRoomId,
    required this.isMe,
    required this.isDeleted,
    required this.decryptedText,
    required this.messageIndex,
    this.senderName, // Add optional sender name
  });

  final ChatController chatController;
  final Message message;
  final String currentUserId;
  final String currentRoomId;
  final bool isMe;
  final bool isDeleted;
  final String decryptedText;
  final int messageIndex;
  final String? senderName; // Add sender name parameter

  void _showDialogPage(BuildContext context) {
    // Get the position of the message widget
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final Offset? position = renderBox?.localToGlobal(Offset.zero);

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder:
            (_, __, ___) => OptionDialogScreen(
              text: decryptedText,
              index: messageIndex,
              isMe: isMe,
              isDeleted: isDeleted,
              heroTag: 'message-${message.messageId}-$messageIndex',
              messagePosition: position,
              messageId: message.messageId,
              senderId: message.senderId,
              senderName: senderName ?? 'Unknown User',
            ),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final heroTag = 'message-${message.messageId}-$messageIndex';

    return GestureDetector(
      onLongPress: () => _showDialogPage(context),
      child: Hero(
        tag: heroTag,
        flightShuttleBuilder: (
          flightContext,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ) {
          final tween = Tween<double>(begin: 0.98, end: 1.02);
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: tween.animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: EnhancedMessageWidget(
                text: decryptedText,
                isMe: isMe,
                createdDate: message.createdAt,
                isDeleted: isDeleted,
                senderName: senderName,
              ),
            ),
          );
        },
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: MessageCard(
            text: decryptedText,
            isMe: isMe,
            isDeleted: isDeleted,
            createdDate: message.createdAt,
            maxWidth: ResponsiveSizeApp(context).screenWidth * 0.8,
          ),
        ),
      ),
    );
  }
}

/// Reusable message card component for consistent Hero animation
class MessageCard extends StatelessWidget {
  final String text;
  final dynamic
  createdDate; // Changed from String to dynamic to accept Timestamp
  final bool isMe;
  final bool isDeleted;
  final double? maxWidth;

  const MessageCard({
    super.key,
    required this.text,
    required this.isMe,
    required this.isDeleted,
    this.maxWidth,
    required this.createdDate,
  });

  Widget _buildMessageText(BuildContext context) {
    // If text is empty or deleted, show simple text
    if (text.isEmpty || isDeleted) {
      return Text(
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
      );
    }

    final hashtagReg = RegExp(r'#\w+');
    final urlReg = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    );
    final matches = <RegExpMatch>[];

    // Find all hashtag and URL matches
    matches.addAll(hashtagReg.allMatches(text));
    matches.addAll(urlReg.allMatches(text));
    matches.sort((a, b) => a.start.compareTo(b.start));

    // If no matches found, show simple text
    if (matches.isEmpty) {
      return Text(
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
      );
    }

    // Build rich text with special handling for hashtags and URLs
    List<TextSpan> spans = [];
    int last = 0;

    for (final match in matches) {
      if (match.start > last) {
        spans.add(
          TextSpan(
            text: text.substring(last, match.start),
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
        );
      }

      // Add the matched text (hashtag or URL)
      final matchedText = text.substring(match.start, match.end);
      final isUrl = urlReg.hasMatch(matchedText);

      spans.add(
        TextSpan(
          text: matchedText,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.lightBlue,
            fontWeight: FontWeight.w500,
          ),
          recognizer:
              isUrl
                  ? (TapGestureRecognizer()
                    ..onTap = () async {
                      final uri = Uri.parse(matchedText);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    })
                  : null,
        ),
      );

      last = match.end;
    }

    // Add remaining text
    if (last < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(last),
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
      );
    }

    return RichText(text: TextSpan(children: spans));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? MediaQuery.of(context).size.width * 0.85,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color:
                isDeleted
                    ? Colors.transparent
                    : isMe
                    ? AppColor.lightBlue
                    : Colors.grey[200],
            border:
                isDeleted
                    ? Border.all(color: AppColor.defaultColor, width: 0.6)
                    : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow:
                isDeleted
                    ? null
                    : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
          ),
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMessageText(context),
                const SizedBox(height: 2),
                Text(
                  formatMessageTime(createdDate),
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        isDeleted
                            ? AppColor.defaultColor.withValues(alpha: 0.7)
                            : isMe
                            ? AppColor.backgroundColor.withValues(alpha: 0.8)
                            : AppColor.defaultColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';

class EnhancedMessageWidget extends StatefulWidget {
  final String text;
  final dynamic createdDate;
  final bool isMe;
  final bool isDeleted;
  final double? maxWidth;
  final String? senderName;

  const EnhancedMessageWidget({
    super.key,
    required this.text,
    required this.isMe,
    required this.isDeleted,
    this.maxWidth,
    required this.createdDate,
    this.senderName,
  });

  @override
  State<EnhancedMessageWidget> createState() => _EnhancedMessageWidgetState();
}

class _EnhancedMessageWidgetState extends State<EnhancedMessageWidget>
    with SingleTickerProviderStateMixin {
  bool _showCopyButton = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép tin nhắn'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCopyButton() {
    return Positioned(
      top: 4,
      right: 4,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.copy, color: Colors.white, size: 16),
            onPressed: _copyToClipboard,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    if (widget.text.isEmpty || widget.isDeleted) {
      return Text(
        widget.text,
        style: TextStyle(
          fontSize: 16,
          color:
              widget.isDeleted
                  ? AppColor.defaultColor
                  : widget.isMe
                  ? AppColor.backgroundColor
                  : AppColor.defaultColor,
        ),
      );
    }

    return _buildFormattedText();
  }

  Widget _buildFormattedText() {
    final spans = <TextSpan>[];
    final text = widget.text;

    // Regular expressions for different patterns
    final codeBlockReg = RegExp(r'```([\s\S]*?)```');
    final inlineCodeReg = RegExp(r'`([^`]+)`');
    final hashtagReg = RegExp(r'#\w+');
    final urlReg = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
    );

    // Collect all matches with their types
    final matches = <({RegExpMatch match, String type})>[];

    matches.addAll(
      codeBlockReg.allMatches(text).map((m) => (match: m, type: 'codeblock')),
    );
    matches.addAll(
      inlineCodeReg.allMatches(text).map((m) => (match: m, type: 'inlinecode')),
    );
    matches.addAll(
      hashtagReg.allMatches(text).map((m) => (match: m, type: 'hashtag')),
    );
    matches.addAll(urlReg.allMatches(text).map((m) => (match: m, type: 'url')));

    // Sort matches by start position
    matches.sort((a, b) => a.match.start.compareTo(b.match.start));

    int last = 0;

    for (final item in matches) {
      final match = item.match;
      final type = item.type;

      // Add text before match
      if (match.start > last) {
        spans.add(
          TextSpan(
            text: text.substring(last, match.start),
            style: _getDefaultTextStyle(),
          ),
        );
      }

      final matchedText = text.substring(match.start, match.end);

      switch (type) {
        case 'codeblock':
          spans.add(_buildCodeBlockSpan(matchedText));
          break;
        case 'inlinecode':
          spans.add(_buildInlineCodeSpan(matchedText));
          break;
        case 'hashtag':
          spans.add(_buildHashtagSpan(matchedText));
          break;
        case 'url':
          spans.add(_buildUrlSpan(matchedText));
          break;
      }

      last = match.end;
    }

    // Add remaining text
    if (last < text.length) {
      spans.add(
        TextSpan(text: text.substring(last), style: _getDefaultTextStyle()),
      );
    }

    if (spans.isEmpty) {
      return Text(text, style: _getDefaultTextStyle());
    }

    return RichText(text: TextSpan(children: spans));
  }

  TextStyle _getDefaultTextStyle() {
    return TextStyle(
      fontSize: 16,
      color:
          widget.isDeleted
              ? AppColor.defaultColor
              : widget.isMe
              ? AppColor.backgroundColor
              : AppColor.defaultColor,
    );
  }

  TextSpan _buildCodeBlockSpan(String code) {
    final cleanCode = code.replaceAll('```', '').trim();
    return TextSpan(
      text: cleanCode,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 14,
        color: widget.isMe ? AppColor.backgroundColor : AppColor.defaultColor,
        backgroundColor:
            widget.isMe
                ? AppColor.backgroundColor.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }

  TextSpan _buildInlineCodeSpan(String code) {
    final cleanCode = code.replaceAll('`', '');
    return TextSpan(
      text: cleanCode,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 15,
        color: widget.isMe ? AppColor.backgroundColor : AppColor.defaultColor,
        backgroundColor:
            widget.isMe
                ? AppColor.backgroundColor.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }

  TextSpan _buildHashtagSpan(String hashtag) {
    return TextSpan(
      text: hashtag,
      style: TextStyle(
        fontSize: 16,
        color: AppColor.lightBlue,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  TextSpan _buildUrlSpan(String url) {
    return TextSpan(
      text: url,
      style: TextStyle(
        fontSize: 16,
        color: AppColor.lightBlue,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
      ),
      recognizer:
          TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _showCopyButton = true;
          });
          _animationController.forward();
        },
        onExit: (_) {
          setState(() {
            _showCopyButton = false;
          });
          _animationController.reverse();
        },
        child: GestureDetector(
          onLongPress: () {
            setState(() {
              _showCopyButton = !_showCopyButton;
            });
            if (_showCopyButton) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  widget.maxWidth ?? MediaQuery.of(context).size.width * 0.85,
            ),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color:
                        widget.isDeleted
                            ? Colors.transparent
                            : widget.isMe
                            ? AppColor.lightBlue
                            : Colors.grey[200],
                    border:
                        widget.isDeleted
                            ? Border.all(
                              color: AppColor.defaultColor,
                              width: 0.6,
                            )
                            : null,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:
                        widget.isDeleted
                            ? null
                            : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.senderName != null && !widget.isMe) ...[
                        Text(
                          widget.senderName!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      _buildMessageContent(),
                      const SizedBox(height: 4),
                      Text(
                        formatMessageTime(widget.createdDate),
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              widget.isDeleted
                                  ? AppColor.defaultColor.withValues(alpha: 0.7)
                                  : widget.isMe
                                  ? AppColor.backgroundColor.withValues(
                                    alpha: 0.8,
                                  )
                                  : AppColor.defaultColor.withValues(
                                    alpha: 0.7,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showCopyButton && !widget.isDeleted) _buildCopyButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

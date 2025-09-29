import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/message/chat_member_model.dart';
import 'package:vdiary_internship/data/models/message/message_model.dart';
import 'package:vdiary_internship/data/models/message/message_status_model.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat-firebase-service/chat_firebase_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/chat-room/chat_message_list_widget.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/chat-room/user_active_check_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({
    super.key,
    required this.userId,
    required this.name,
    required this.userAvatar,
  });

  final String userId;
  final String name;
  final String userAvatar;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();
  String? roomId;
  bool isLoading = false;
  bool _initialized = false;
  bool _isTextFieldFocused = false;

  final List<dynamic> optionMores = [
    {'title': 'Share a file', 'icon': ImagePath.shareIcon, 'func': () {}},
    {'title': 'Location', 'icon': ImagePath.locationIcon, 'func': () {}},
    {'title': 'Play games', 'icon': ImagePath.gameIcon, 'func': () {}},
    {'title': 'Imagine', 'icon': ImagePath.imagineIcon, 'func': () {}},
    {'title': 'BoAI', 'icon': ImagePath.boAIIcon, 'func': () {}},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      fetchRoomId();
      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    // Listen to focus changes
    messageFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = messageFocusNode.hasFocus;
      });
    });
  }

  Future<void> fetchRoomId() async {
    setState(() {
      isLoading = true;
    });
    final userInfo = context.authStore.userInfo;
    final currentUserId = userInfo != null ? userInfo['_id'] ?? '' : '';
    final id = await ChatFirebaseService().getChatRoomIdForPrivate(
      currentUserId,
      widget.userId,
    );
    setState(() {
      roomId = id;
      isLoading = false;
    });
  }

  Future<void> fetchRoomIdAndSendMessage(String content) async {
    final userInfo = context.authStore.userInfo;
    final currentUserId = userInfo != null ? userInfo['_id'] ?? '' : '';
    String? id = roomId;
    if (id == null) {
      id = await ChatFirebaseService().getChatRoomIdForPrivate(
        currentUserId,
        widget.userId,
      );
      id ??= await ChatFirebaseService().createChatRoom(
        type: 'private',
        members: [
          ChatMember(
            userId: currentUserId,
            role: 'member',
            lastSeenMessageId: '',
            joinedAt: Timestamp.now(),
          ),
          ChatMember(
            userId: widget.userId,
            role: 'member',
            lastSeenMessageId: '',
            joinedAt: Timestamp.now(),
          ),
        ],
        createBy: currentUserId,
      );
      debugPrint('ROOM ID: $id');
      setState(() {
        roomId = id;
      });
    }
    final message = Message(
      messageId: '',
      senderId: currentUserId,
      type: 'text',
      text: content,
      images: [],
      createdAt: Timestamp.now(),
      status: MessageStatus(deliveredTo: [], readBy: []),
    );
    await ChatFirebaseService().sendMessage(roomId: id, message: message);
  }

  void sendMessage() async {
    final content = messageController.text.trim();
    if (content.isEmpty) return;

    final chatStore = context.chatStore;

    // Check if this is a reply
    if (chatStore.isReplying) {
      debugPrint('Sending reply to: ${chatStore.replyTargetMessageId}');
      debugPrint('Reply content: $content');
      // TODO: Implement reply message sending with replyToMessageId
      // You'll need to modify your ChatFirebaseService to handle replies
    }

    await fetchRoomIdAndSendMessage(content);
    messageController.clear();

    // Clear reply state after sending
    chatStore.clearReplyTarget();
  }

  void _openPopUpSettingMore(BuildContext context, GlobalKey key) {
    final contextIcon = key.currentContext;
    if (contextIcon == null) return;
    final renderObject = contextIcon.findRenderObject();
    if (renderObject == null || renderObject is! RenderBox) return;
    // ignore: unnecessary_cast
    final box = renderObject as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    // ## Unfocus button
    FocusScope.of(context).unfocus();

    showMenu(
      context: context,
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 500),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy - size.height - 280, // đẩy cao hơn một chút
        position.dx + size.width,
        position.dy,
      ),
      items: [
        ...optionMores.map(
          (item) => PopupMenuItem(
            child: Builder(
              builder: (context) {
                final String? title =
                    item['title'] is String ? item['title'] : null;
                final String? iconPath =
                    item['icon'] is String ? item['icon'] : null;
                final func = item['func'];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  onTap: () {
                    if (func is VoidCallback) {
                      func();
                    }
                    Navigator.pop(context);
                    Future.delayed(Duration.zero, () {
                      FocusScope.of(context).unfocus();
                    });
                  },
                  leading: title != null ? Text(title) : const SizedBox(),
                  trailing:
                      (iconPath != null && iconPath.isNotEmpty)
                          ? SvgPicture.asset(iconPath, width: 15, height: 15)
                          : const SizedBox(width: 20, height: 20),
                );
              },
            ),
          ),
        ),
      ],
    ).then((_) {
      Future.delayed(Duration(milliseconds: 50), () {
        FocusScope.of(context).unfocus();
      });
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.authStore.userInfo;
    final currentUserId = userInfo != null ? userInfo['_id'] ?? '' : '';
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: chatMessageHeader(
        context,
        widget.userId,
        widget.name,
        widget.userAvatar,
        roomId ?? '',
      ),
      body: Column(
        children: [
          HSpacing(20),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child:
                  roomId == null
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                        onRefresh: () async {
                          await fetchRoomId(); // hoặc các thao tác async khác
                          ChatFirebaseService().getMessagesStream(roomId ?? '');
                          setState(() {});
                        },
                        child: ChatMessageListWidget(
                          roomId: roomId!,
                          currentUserId: currentUserId,
                        ),
                      ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Observer(
                  builder: (context) {
                    final chatStore = context.chatStore;
                    final isReplying = chatStore.isReplying;
                    return isReplying
                        ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.superLightGrey,
                            border: Border(
                              left: BorderSide(
                                color: AppColor.lightBlue,
                                width: 4,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Replying to ${widget.name}',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.lightBlue,
                                          ),
                                    ),
                                    HSpacing(2),
                                    Text(
                                      chatStore.replyTargetMessageText,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppColor.defaultColor
                                                .withValues(alpha: 0.7),
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  chatStore.clearReplyTarget();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: AppColor.mediumGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : const SizedBox.shrink();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Show action buttons only when TextField is not focused
                      if (!_isTextFieldFocused)
                        Builder(
                          builder: (context) {
                            final GlobalKey iconKey = GlobalKey();
                            return InkWell(
                              key: iconKey,
                              splashColor: AppColor.backgroundColor.withValues(
                                alpha: 0.5,
                              ),
                              onTap: () {
                                _openPopUpSettingMore(context, iconKey);
                              },
                              child: Icon(
                                FluentIcons.add_circle_20_filled,
                                size: 24,
                                color: AppColor.lightBlue,
                              ),
                            );
                          },
                        ),
                      if (!_isTextFieldFocused) WSpacing(4),
                      if (!_isTextFieldFocused)
                        Icon(
                          FluentIcons.camera_20_filled,
                          size: 24,
                          color: AppColor.lightBlue,
                        ),
                      if (!_isTextFieldFocused) WSpacing(4),
                      if (!_isTextFieldFocused)
                        Icon(
                          FluentIcons.image_20_filled,
                          size: 24,
                          color: AppColor.lightBlue,
                        ),
                      if (!_isTextFieldFocused) WSpacing(4),
                      if (!_isTextFieldFocused)
                        Icon(
                          FluentIcons.mic_20_filled,
                          size: 24,
                          color: AppColor.lightBlue,
                        ),
                      if (!_isTextFieldFocused) WSpacing(5),
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          focusNode: messageFocusNode,
                          style: context.textTheme.bodyMedium,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.superLightGrey,
                            hintText:
                                context.chatStore.isReplying
                                    ? 'Reply to ${context.chatStore.replyTargetUserName}...'
                                    : 'Type a message...',
                            hintStyle: context.textTheme.bodySmall?.copyWith(
                              color: AppColor.mediumGrey,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            suffixIcon: Icon(
                              FluentIcons.emoji_20_filled,
                              color: AppColor.lightBlue,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: AppColor.lightBlue.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (_) => sendMessage(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          FluentIcons.send_24_filled,
                          color: AppColor.lightBlue,
                        ),
                        onPressed: sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

AppBar chatMessageHeader(
  BuildContext context,
  String userId,
  String name,
  String avatar,
  String roomId,
) {
  return AppBar(
    automaticallyImplyLeading: false,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => AppNavigator.pop(context),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 25,
                  color: AppColor.lightBlue,
                ),
              ),
              WSpacing(5),
              UserActiveCheckWidget(
                userId: userId,
                avatarUrl: avatar,
                size: 50,
              ),
              WSpacing(10),
              InkWell(
                splashColor: AppColor.lightGrey,
                onTap:
                    () => AppNavigator.toChatRoomDetail(
                      context,
                      userId: userId,
                      userName: name,
                      userAvatar: avatar,
                      roomId: roomId,
                    ),
                child: Text(
                  name,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.defaultColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Row(
            children: [
              Icon(
                FluentIcons.call_20_filled,
                size: 30,
                color: AppColor.lightBlue,
              ),
              Icon(
                FluentIcons.video_chat_20_filled,
                size: 30,
                color: AppColor.lightBlue,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

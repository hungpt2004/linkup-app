import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/message/chat_member_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat-firebase-service/chat_firebase_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/message_encrypt_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/chat-room/user_active_check_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/avatar_build_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class ChatUserSectionWidget extends StatefulWidget {
  const ChatUserSectionWidget({
    super.key,
    required this.index,
    required this.userIndex,
  });

  final int index;
  final UserModel userIndex;

  @override
  State<ChatUserSectionWidget> createState() => _ChatUserSectionWidgetState();
}

class _ChatUserSectionWidgetState extends State<ChatUserSectionWidget> {
  Stream<Map<String, dynamic>?> lastMessageStream() async* {
    final currentUserId = context.authStore.userInfo?['_id'] ?? '';
    final roomId = await ChatFirebaseService().getChatRoomIdForPrivate(
      currentUserId,
      widget.userIndex.id ?? '',
    );
    if (roomId == null) {
      yield null;
      return;
    }

    yield* FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(roomId)
        .snapshots()
        .asyncMap((roomDoc) async {
          final lastMessage = roomDoc.data()?['lastMessage'];
          if (lastMessage == null) return null;

          final messageId = lastMessage['messageId'];
          if (messageId == null) return lastMessage;

          // Lấy thêm thông tin status từ collection messages
          final messageDoc =
              await FirebaseFirestore.instance
                  .collection('chat_rooms')
                  .doc(roomId)
                  .collection('messages')
                  .doc(messageId)
                  .get();

          if (messageDoc.exists) {
            final messageData = messageDoc.data();
            // Kết hợp lastMessage với status từ message document
            return {
              ...lastMessage,
              'status': messageData?['status'], // Thêm status vào lastMessage
            };
          }

          return lastMessage;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(widget.index),
      dragStartBehavior: DragStartBehavior.down,
      enabled: true,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.6,
        dragDismissible: true,
        children: [
          /// Action 1: More (SVG)
          _buildCustomSlidableAction(
            context,
            color: Colors.grey.shade300,
            function: () => {},
            title: 'More',
            imagePathIcon: ImagePath.moreIcon,
          ),

          /// Action 2: Pin (SVG)
          _buildCustomSlidableAction(
            context,
            color: Colors.yellow.shade800,
            function: () => {},
            title: 'Pin',
            imagePathIcon: ImagePath.pinIcon,
          ),

          /// Action 3: Delete (SVG)
          _buildCustomSlidableAction(
            context,
            color: Colors.deepPurple,
            function: () => {},
            title: 'Archive',
            imagePathIcon: ImagePath.archiveIcon,
          ),
        ],
      ),

      child: Observer(
        builder: (_) {
          final userInfo = context.authStore.userInfo;
          final chatLoading = context.chatStore.isLoading;
          return InkWell(
            splashColor: AppColor.lightGrey,
            onTap:
                chatLoading
                    ? () => {}
                    : () async {
                      final isExist = await context.chatStore.checkExistRoom(
                        membersIds: [
                          userInfo?['id'] ?? 'Mem1',
                          widget.userIndex.id ?? 'Mem2',
                        ],
                      );

                      // UPDATE READBY
                      final currentUserId = userInfo?['_id'] ?? '';
                      final currentAvatar = userInfo?['avatar'] ?? '';
                      final otherUserId = widget.userIndex.id ?? '';
                      final roomId = await ChatFirebaseService()
                          .getChatRoomIdForPrivate(currentUserId, otherUserId);

                      if (roomId != null) {
                        // Lấy messageId của tin nhắn cuối từ lastMessage
                        final roomDoc =
                            await FirebaseFirestore.instance
                                .collection('chat_rooms')
                                .doc(roomId)
                                .get();
                        final lastMessage = roomDoc.data()?['lastMessage'];
                        final messageId = lastMessage?['messageId'];

                        if (messageId != null) {
                          await ChatFirebaseService().updateReadBy(
                            null,
                            currentUserId: currentUserId,
                            currentUserAvatar: currentAvatar,
                            otherUserId: otherUserId,
                            roomId: roomId,
                            messageId: messageId,
                          );
                        }
                      }

                      if (isExist) {
                        AppNavigator.toChatRoomScreen(
                          context,
                          userId: widget.userIndex.id ?? '',
                          name: widget.userIndex.name ?? '',
                          userAvatar:
                              widget.userIndex.avatarUrl ??
                              ImagePath.avatarDefault,
                        );
                      } else {
                        await ChatFirebaseService().createChatRoom(
                          type: 'private',
                          members: [
                            ChatMember(
                              userId: userInfo?['_id'],
                              role: 'member',
                              lastSeenMessageId: '',
                              joinedAt: Timestamp.now(),
                            ),
                            ChatMember(
                              userId: widget.userIndex.id ?? '',
                              role: 'member',
                              lastSeenMessageId: '',
                              joinedAt: Timestamp.now(),
                            ),
                          ],
                          createBy: userInfo?['_id'] ?? '',
                        );
                        await Future.delayed(
                          Duration(milliseconds: 300),
                          () => AppNavigator.toChatRoomScreen(
                            context,
                            userId: widget.userIndex.id ?? '',
                            name: widget.userIndex.name ?? '',
                            userAvatar:
                                widget.userIndex.avatarUrl ??
                                ImagePath.avatarDefault,
                          ),
                        );
                      }
                    },
            child: StreamBuilder<Map<String, dynamic>?>(
              stream: lastMessageStream(),
              builder: (context, snapshot) {
                return Observer(
                  builder: (_) {
                    String lastText = '';
                    String senderId = '';
                    String messageId = '';
                    bool showUnreadIndicator = false;

                    final currentUserAvatar =
                        context.authStore.userInfo?['avatar'];

                    if (snapshot.hasData && snapshot.data != null) {
                      // Lấy thông tin lastMessage
                      final text = snapshot.data?['text'];
                      if (text is String) {
                        lastText = text;
                      } else if (text is List && text.isNotEmpty) {
                        lastText = text.join(', ');
                      }

                      final sender = snapshot.data?['senderId'];
                      if (sender is String) {
                        senderId = sender;
                      }

                      final msgId = snapshot.data?['messageId'];
                      if (msgId is String) {
                        messageId = msgId;
                      }

                      // Sử dụng ChatStore để kiểm tra trạng thái đọc và cập nhật lastText
                      final currentUserId = context.authStore.userInfo?['_id'];
                      final readByList = snapshot.data?['status']?['readBy'];

                      if (currentUserId != null && messageId.isNotEmpty) {
                        // Cập nhật lastText vào store
                        final roomId = widget.userIndex.id ?? '';
                        if (lastText.isNotEmpty) {
                          context.chatStore.updateLastMessageText(
                            roomId,
                            lastText,
                          );
                        }

                        // Kiểm tra unread indicator
                        showUnreadIndicator = context.chatStore
                            .shouldShowUnreadIndicator(
                              messageId: messageId,
                              senderId: senderId,
                              currentUserId: currentUserId,
                              readByList: readByList,
                            );
                      }
                    }

                    return ListTile(
                      leading: UserActiveCheckWidget(
                        userId: widget.userIndex.id ?? '',
                        avatarUrl: widget.userIndex.avatarUrl,
                      ),
                      title: Text(
                        widget.userIndex.name ?? '',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        _buildSubtitleText(lastText, senderId),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color:
                              showUnreadIndicator
                                  ? AppColor.defaultColor
                                  : AppColor.mediumGrey,
                          fontWeight:
                              showUnreadIndicator
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                        ),
                      ),
                      trailing:
                          showUnreadIndicator
                              ? Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade100,
                                  shape: BoxShape.circle,
                                ),
                              )
                              : AvatarBoxShadowWidget(
                                imageUrl: currentUserAvatar,
                                width: 15,
                                height: 15,
                              ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _buildSubtitleText(String lastText, String senderId) {
    if (lastText.isEmpty) {
      return 'Start conversation with ${widget.userIndex.name}';
    }

    final currentUserId = context.authStore.userInfo?['_id'];
    final decryptedText = decryptMessage(lastText);

    // Cập nhật vào store để có thể sử dụng ở chỗ khác
    final roomId = widget.userIndex.id ?? '';
    context.chatStore.updateLastMessageText(roomId, decryptedText);

    return senderId == currentUserId
        ? 'You: $decryptedText'
        : '${widget.userIndex.name}: $decryptedText';
  }

  CustomSlidableAction _buildCustomSlidableAction(
    BuildContext context, {
    required String imagePathIcon,
    required String title,
    required VoidCallback function,
    required Color color,
  }) {
    return CustomSlidableAction(
      padding: EdgeInsets.zero,
      onPressed: (_) => function(),
      backgroundColor: color, // background tràn hết khối
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(imagePathIcon, width: 24, height: 24),
            HSpacing(10),
            Text(
              title,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vdiary_internship/data/models/message/message_model.dart';
import 'package:vdiary_internship/presentation/pages/chat/controller/chat_controller.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat-firebase-service/chat_firebase_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/message_encrypt_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/chat-room/message_section_widget.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/not_found/no_data_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';

class ChatMessageListWidget extends StatefulWidget {
  final String roomId;
  final String currentUserId;

  const ChatMessageListWidget({
    super.key,
    required this.roomId,
    required this.currentUserId,
  });

  @override
  State<ChatMessageListWidget> createState() => _ChatMessageListWidgetState();
}

class _ChatMessageListWidgetState extends State<ChatMessageListWidget> {
  late ChatController chatController;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollToBottomBtn = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    chatController = ChatController(chatStore: context.chatStore);
    super.didChangeDependencies();
  }

  // Scroll Listener
  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    final threshold = 200;
    final isAtBottom =
        _scrollController.offset >=
        _scrollController.position.maxScrollExtent - threshold;
    _showScrollToBottomBtn.value = !isAtBottom;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showScrollToBottomBtn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<List<Message>>(
          stream: ChatFirebaseService().getMessagesStream(widget.roomId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: NoDataWidget(width: 300, height: 300));
            }

            final messages = snapshot.data!;

            // Auto scroll nếu user đang ở gần bottom
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_showScrollToBottomBtn.value) {
                _scrollToBottom();
              }
            });

            return ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final decryptedText = decryptMessage(message.text ?? "");
                final isMe = message.senderId == widget.currentUserId;
                final isDeleted = message.isDeleted;
                final currentUserId = widget.currentUserId;
                final currentRoomId = widget.roomId;

                return MessageSectionWidget(
                  chatController: chatController,
                  message: message,
                  currentUserId: currentUserId,
                  currentRoomId: currentRoomId,
                  isMe: isMe,
                  isDeleted: isDeleted,
                  decryptedText: decryptedText,
                  messageIndex: index,
                );
              },
            );
          },
        ),

        // Nút scroll to bottom
        Positioned(
          bottom: 5,
          right: 0,
          left: 0,
          child: Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: _showScrollToBottomBtn,
              builder: (context, show, _) {
                if (!show) return const SizedBox.shrink();
                return FloatingActionButton(
                  mini: true,
                  onPressed: _scrollToBottom,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: AppColor.superLightBlue,
                  child: Center(
                    child: const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: AppColor.lightBlue,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

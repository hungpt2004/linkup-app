import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/loading_chat_bubble_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/store/store_factory.dart';
import 'package:vdiary_internship/presentation/shared/widgets/not_found/no_data_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

// RELATIVE IMPORT
import '../controller/chat_controller.dart';

class ChatBoxScreen extends StatefulWidget {
  const ChatBoxScreen({super.key});

  @override
  _ChatBoxScreenState createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  late final ChatController _chatController;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StoreFactory.chatStore.initialize();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _chatController = ChatController(chatStore: context.chatStore);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () => AppNavigator.toDashboard(context, tabIndex: 0),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColor.defaultColor,
              ),
            ),
            Text('Chat với BoAI'),
          ],
        ),
      ),
      body: Observer(
        builder: (_) {
          final chatStore = context.chatStore;
          final listMessageChatBox = chatStore.listChatBoxMessages;
          if (listMessageChatBox.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Center(child: NoDataWidget(width: 200, height: 200)),
                ),
                _buildMessageInput(context),
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: listMessageChatBox.length,
                  itemBuilder: (context, index) {
                    final message = listMessageChatBox[index];
                    return Column(
                      children: [
                        _buildMessageBubble(
                          message.sendMessage,
                          false,
                        ), // message của người dùng
                        message.responseMessage == null
                            ? LoadingChatBubbleWidget()
                            : _buildMessageBubble(
                              message.responseMessage!,
                              true,
                            ),
                      ],
                    );
                  },
                ),
              ),
              _buildMessageInput(context),
            ],
          );
        },
      ),
    );
  }

  // Widget tin nhắn tùy chỉnh
  Widget _buildMessageBubble(String text, bool isAI) {
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: 6.0,
            bottom: 6.0,
            left: isAI ? 8.0 : 50.0,
            right: isAI ? 50.0 : 8.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isAI ? Colors.grey[200] : AppColor.lightBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(isAI ? 0 : 15),
              bottomRight: Radius.circular(!isAI ? 0 : 15),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(color: isAI ? Colors.black87 : Colors.white),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }

  // Widget ô nhập tin nhắn
  Widget _buildMessageInput(BuildContext contex) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColor.mediumGrey, width: 0.5)),
      ),
      child: SizedBox(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    minLines: 1,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColor.defaultColor,
                    ),
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.mediumGrey,
                      ),
                      filled: true,
                      fillColor: AppColor.backgroundColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: AppColor.backgroundColor,
                          width: 0.5,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                WSpacing(10),
                GestureDetector(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: SvgPicture.asset(ImagePath.sendIcon),
                  ),
                  onTap: () async {
                    await _chatController.sendMessageChatBox(
                      _contentController.text,
                    );
                    _contentController.clear();
                  },
                ),
              ],
            ),
            Text('Google LLM'),
          ],
        ),
      ),
    );
  }
}

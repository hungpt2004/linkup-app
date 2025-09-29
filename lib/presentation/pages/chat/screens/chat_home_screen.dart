import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/pages/chat/controller/chat_controller.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/chat-room/chat_user_list_widget.dart';
import 'package:vdiary_internship/presentation/pages/friends/controller/friends_controller.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class ChatGroupScreen extends StatefulWidget {
  const ChatGroupScreen({super.key});

  @override
  State<ChatGroupScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatGroupScreen> {
  late ChatController chatController;
  late FriendController friendController;

  @override
  void didChangeDependencies() {
    chatController = ChatController(chatStore: context.chatStore);
    friendController = FriendController(context.friendStore, context.userStore);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await friendController.handleGetAllFriends(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: PreferredSize(
            preferredSize: Size(
              ResponsiveSizeApp(context).screenWidth,
              kToolbarHeight,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'M E S S A G E',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColor.lightBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImagePath.editIcon,
                        width: 25,
                        height: 25,
                      ),
                      WSpacing(10),
                      GestureDetector(
                        onTap:
                            () =>
                                AppNavigator.toDashboard(context, tabIndex: 0),
                        child: SvgPicture.asset(
                          ImagePath.homeBackIcon,
                          width: 25,
                          height: 25,
                        ),
                      ),
                      WSpacing(10),
                      GestureDetector(
                        onTap:
                            () => chatController.openSettingChatGroup(context),
                        child: SvgPicture.asset(
                          ImagePath.settingNewIcon,
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ChatGroupListWidget(),
        floatingActionButton: Observer(
          builder: (_) {
            final conversationLoading = context.chatStore.isLoading;
            return conversationLoading
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColor.superLightBlue,
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min, // 👈 Quan trọng: co giãn theo child
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.lightBlue,
                        ),
                      ),
                      const SizedBox(width: 8), // 👈 tạo khoảng cách với text
                      const Text('Loading chat session'),
                    ],
                  ),
                )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

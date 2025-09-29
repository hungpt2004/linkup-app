import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat-firebase-service/chat_firebase_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/setting_list_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/extensions/bottom_sheet_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/dialog_extension.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';

// RELATIVE IMPORT
import '../store/chat_store.dart';

class ChatController {
  final ChatStore chatStore;

  ChatController({required this.chatStore});

  Future<void> sendMessageChatBox(String content) async {
    var success = await chatStore.sendChatBoxMessage(content);
    success ? debugPrint('Send message success') : null;
  }

  Future<void> sendRequestSummaryText(
    BuildContext context,
    postId,
    String content,
  ) async {
    var success = await chatStore.sendRequestSummaryText(postId, content);
    success
        // ignore: use_build_context_synchronously
        ? ToastAppWidget.showSuccessToast(context, 'Summary success')
        // ignore: use_build_context_synchronously
        : ToastAppWidget.showErrorToast(context, 'Summary failed ! Try again');
  }

  void openSettingChatGroup(BuildContext context) {
    context.showCustomDialog(
      barrierDismissible: true,
      showCloseButton: true,
      width: ResponsiveSizeApp(context).screenWidth * 0.8,
      height: ResponsiveSizeApp(context).heightPercent(250),
      title: 'Chat Interface Setting',
      subtitle: 'Customize your setting',
      child: SettingChatGroupListWidget(),
    );
  }

  void openSettingMessage(
    BuildContext context,
    String senderId,
    String currentUserId, {
    required String messageId,
    required String roomId,
  }) {
    final isAllow = senderId == currentUserId;
    context.showBottomSheet(
      height: ResponsiveSizeApp(context).screenHeight * 0.32,
      isScrollControlled: true,
      child: Column(
        children: [
          ListTile(
            leading: Text('Reply', style: context.textTheme.bodyMedium),
            splashColor: AppColor.lightGrey,
            trailing: Icon(FluentIcons.share_20_filled),
          ),
          ListTile(
            leading: Text('Copy', style: context.textTheme.bodyMedium),
            splashColor: AppColor.lightGrey,
            trailing: Icon(FluentIcons.copy_20_filled),
          ),
          ListTile(
            onTap: () async {
              await ChatFirebaseService().deleteMessage(
                messageId: messageId,
                roomId: roomId,
                userId: currentUserId,
              );
              AppNavigator.pop(context);
            },
            leading:
                isAllow
                    ? Text('Delete', style: context.textTheme.bodyMedium)
                    : Text('Translate', style: context.textTheme.bodyMedium),
            splashColor: AppColor.lightGrey,
            trailing: Icon(
              isAllow
                  ? FluentIcons.delete_20_filled
                  : FluentIcons.translate_20_filled,
            ),
          ),
        ],
      ),
      text: 'Setting message',
    );
  }

  // gallery custom

  // bottomsheet create group
  void openSettingCreateGroup(BuildContext context) {
    
  }


  void clearMapSummaryData() {
    chatStore.clearDataSummaryMap();
  }
}

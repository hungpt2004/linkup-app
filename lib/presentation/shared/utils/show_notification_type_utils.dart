import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:vdiary_internship/core/constants/api/end_point.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';

Map<String, Map<dynamic, dynamic>> notificationTypeAndColor(
  TypeNotification typeNotification,
) {
  switch (typeNotification) {
    case TypeNotification.post:
      return {
        'post': {
          'color': AppColor.successGreen,
          'icon': FluentIcons.book_letter_20_regular,
        },
      };
    case TypeNotification.chat:
      return {
        'chat': {
          'color': AppColor.lightBlue,
          'icon': FluentIcons.chat_20_regular,
        },
      };
    case TypeNotification.chatbox:
      return {
        'chatbox': {
          'color': AppColor.lightBlue,
          'icon': FluentIcons.chat_bubbles_question_20_regular,
        },
      };
    case TypeNotification.comment:
      return {
        'comment': {
          'color': AppColor.mediumGrey,
          'icon': FluentIcons.chat_empty_16_regular,
        },
      };
    case TypeNotification.system:
      return {
        'system': {
          'color': AppColor.errorRed,
          'icon': FluentIcons.alert_24_regular,
        },
      };
    // ignore: unreachable_switch_default
    default:
      return {};
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/presentation/pages/chat/widgets/chat-room/user_active_check_widget.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';
import 'package:vdiary_internship/presentation/shared/widgets/layout/padding_layout.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_responsive_size.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';

class ChatRoomDetailScreen extends StatefulWidget {
  const ChatRoomDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.roomId,
  });

  final String userId;
  final String userName;
  final String userAvatar;
  final String roomId;

  @override
  State<ChatRoomDetailScreen> createState() => _ChatRoomDetailScreenState();
}

class _ChatRoomDetailScreenState extends State<ChatRoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => AppNavigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        surfaceTintColor: AppColor.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserActiveCheckWidget(
                userId: widget.userId,
                avatarUrl: widget.userAvatar,
                size: 100,
              ),
              HSpacing(16),
              Text(
                widget.userName,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColor.defaultColor,
                ),
              ),
              HSpacing(5),
              Container(
                width: ResponsiveSizeApp(context).widthPercent(180),
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Expanded(
                  child: PaddingLayout.symmetric(
                    vertical: 2,
                    horizontal: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          ImagePath.lockBlackIcon,
                          width: 12,
                          height: 12,
                        ),
                        WSpacing(5),
                        Text(
                          'End-to-end encrypted',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

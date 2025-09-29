import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import '../../../themes/theme/app_theme.dart';
import '../../../routes/app_navigator.dart';
import '../../../themes/theme/responsive/app_space_size.dart';
import '../../utils/format_time_ago.dart';
import '../images/avatar_build_widget.dart';

class AppBarWithUserInforWidget extends StatelessWidget {
  const AppBarWithUserInforWidget({super.key, required this.currentPost});

  final PostModel currentPost;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          IconButton(
            onPressed: () => AppNavigator.toDashboard(context, tabIndex: 0),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: IconSizeApp.iconSizeMedium,
            ),
          ),
          WSpacing(10),
          AvatarBoxShadowWidget(
            height: 40,
            width: 40,
            imageUrl: currentPost.user.avatarUrl!,
          ),
          WSpacing(10),
          SizedBox(
            height: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentPost.user.name!,
                  textAlign: TextAlign.start,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${formatTimeAgo(currentPost.createdAt.toString())}・',
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.mediumGrey,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: SvgPicture.asset(
                        currentPost.privacy == 'public'
                            ? ImagePath.earthIcon
                            : ImagePath.friendImageIcon,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

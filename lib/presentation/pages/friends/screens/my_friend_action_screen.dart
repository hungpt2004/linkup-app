import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vdiary_internship/core/constants/mock/mock_data.dart';
import 'package:vdiary_internship/core/constants/gen/image_path.dart';
import 'package:vdiary_internship/data/models/tab/tab.model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/presentation/pages/friends/controller/friends_controller.dart';
import 'package:vdiary_internship/presentation/pages/friends/controller/user_controller.dart';
import 'package:vdiary_internship/presentation/shared/extensions/animation_wrapper_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/utils/format_time_ago.dart';
import 'package:vdiary_internship/presentation/shared/widgets/images/image_widget.dart';
import 'package:vdiary_internship/presentation/shared/widgets/loading/animation_loading.dart';
import 'package:vdiary_internship/presentation/themes/animation/animation_wrapper.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';
import 'package:vdiary_internship/presentation/themes/theme/responsive/app_space_size.dart';
import '../../../../core/constants/size/size_app.dart';
import '../../../themes/theme/app-color/app_color.dart';
import '../../../themes/theme/layout/loading-layout/loading_layout.dart';
import '../../../themes/theme/responsive/app_responsive_size.dart';

class MyFriendActionScreen extends StatefulWidget {
  const MyFriendActionScreen({super.key});

  @override
  State<MyFriendActionScreen> createState() => _MyFriendActionScreenState();
}

class _MyFriendActionScreenState extends State<MyFriendActionScreen> {
  late UserController _userController;
  late FriendController _friendController;
  final RefreshController _refreshController = RefreshController();
  List<UserModel> _currentList = [];

  // Thanh action loại bạn bè
  List<String> typeActions = [];
  int selectedTypeIndex = 0;

  // Thanh action của từng bạn
  TabModel? selectedTab;

  @override
  void didChangeDependencies() {
    _userController = UserController(context.userStore);
    _friendController = FriendController(
      context.friendStore,
      context.userStore,
    );
    super.didChangeDependencies();
  }

  Future<void> loadDataTypeAction() async {
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      typeActions = MockData.typeAction;
      selectedTypeIndex = 0;
    });
    await _onTypeActionTap(0);
  }

  Future<List<UserModel>> loadDataTypeUser(int index) async {
    switch (index) {
      case 0:
        await _friendController.handleGetAllFriends(context);
        // ignore: use_build_context_synchronously
        return context.friendStore.friends;
      case 1:
        await _userController.handleGetAllUser(context);
        // ignore: use_build_context_synchronously
        return context.userStore.suggestions;
      case 2:
        await _friendController.handleGetAllRequests();
        // ignore: use_build_context_synchronously
        return context.friendStore.friendRequestsTest;
      case 3:
        await _friendController.handleGetFollowers();
        // ignore: use_build_context_synchronously
        return context.friendStore.followers;
      case 4:
        await _friendController.handleGetFollowing();
        // ignore: use_build_context_synchronously
        return context.friendStore.following;
      default:
        await _friendController.handleGetAllFriends(context);
        // ignore: use_build_context_synchronously
        return context.friendStore.friends;
    }
  }

  // Hàm xử lý khi chọn tab
  Future<void> _onTypeActionTap(int index) async {
    setState(() {
      selectedTypeIndex = index;
      _currentList = [];
    });
    final listTypeActionData = await loadDataTypeUser(index);
    if (!mounted) return;
    setState(() {
      _currentList = listTypeActionData;
    });
  }

  // Hàm xử lý khi chọn tiến trình của từng user
  void onTabSelected(TabModel tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  Widget _listTypeAction() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: typeActions.length,
      itemBuilder: (_, i) {
        final sel = i == selectedTypeIndex;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: GestureDetector(
            onTap: () => _onTypeActionTap(i),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color:
                        sel
                            ? AppColor.lightBlue
                            : AppColor.mediumGrey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      typeActions[i],
                      style: TextStyle(
                        fontSize: FontSizeApp.fontSizeSubMedium,
                        fontWeight: FontWeight.w500,
                        color: sel ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    loadDataTypeAction();
    super.initState();
  }

  // Hàm dựng dialog
  void showCustomDialog({
    required BuildContext context,
    required Widget child,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Color barrierColor = const Color(0x80000000), // Màu đen mờ
    bool barrierDismissible = true,
  }) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Dialog",
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (_, __, ___) => Center(child: child),
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1), // trượt từ dưới lên
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  // Bottom sheet: truyền user vào để tạo callback động
  void showSettingFriend(UserModel user) {
    final tabs = MockData.tabs(
      onUnfriend: () {
        showDialog(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text('Unfriend'),
                content: Text('Are you sure you want to unfriend this user?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _friendController.handleUnfriendUser(user.id!);
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'Unfriend',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );
      },
    );
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                _directionTabBar(context),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: tabs.length,
                    itemBuilder: (_, i) {
                      final tab = tabs[i];
                      return _buildTabBottomSheet(
                        tab.text,
                        tab.icon,
                        tab,
                        false,
                        () {
                          if (tab.onTap != null) {
                            tab.onTap!();
                          } else {
                            onTabSelected(tab);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userStore = context.userStore;
    final friendStore = context.friendStore;
    return LoadingPageLayout(
      loadFuture: loadDataTypeAction,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HSpacing(kToolbarHeight),
            // Danh sách các hành động đầu trang
            SizedBox(
              height: ResponsiveSizeApp(context).heightPercent(40),
              child: _listTypeAction(),
            ),

            // Khoảng cách
            HSpacing(10),

            // Text Friend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${friendStore.friends.isEmpty ? userStore.suggestions.length : friendStore.friends.length} friends',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: FontSizeApp.fontSizeSubMedium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Thẻ người dùng với PullToRefresh
            Expanded(
              child: Observer(
                builder:
                    (_) => SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      onRefresh: () async {
                        await _onTypeActionTap(selectedTypeIndex);
                        _refreshController.refreshCompleted();
                      },
                      child:
                          (friendStore.isLoading || userStore.isLoading)
                              ? Center(child: AnimationLoadingWidget())
                              : _listCardUser(
                                _userController,
                                _friendController,
                                selectedTypeIndex,
                                (user) => showSettingFriend(user),
                                _currentList,
                                context,
                              ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _listCardUser(
  UserController userController,
  FriendController friendController,
  int typeIndex,
  void Function(UserModel) onShowSettingFriend,
  List<UserModel> userList,
  BuildContext context,
) {
  if (userList.isEmpty) {
    return Center(child: _notiNoneData(context));
  }

  return ListView.builder(
    itemCount: userList.length,
    physics: AlwaysScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    clipBehavior: Clip.antiAlias,
    shrinkWrap: true,
    itemBuilder: (ctx, index) {
      final user = userList[index];
      Widget card;
      switch (typeIndex) {
        case 1:
          card = _cardUserSuggestion(
            () {
              friendController.handleAddFriend(user.id!);
            },
            () {},
            () {
              friendController.handleFollowUser(user.id!);
            },
            context,
            user,
          );
          break;
        case 2:
          card = _cardUserRequest(
            () {
              friendController.handleAcceptRequests(user.id!, context);
            },
            () {
              friendController.handleRejectAddFriendRequest(user.id!);
            },
            context,
            user,
          );
          break;
        case 3:
          card = _cardFollower(user, context);
          break;
        case 4:
          card = _cardFollowUser(user, context, () {
            friendController.handleUnfollowUser(user.id!);
          });
          break;
        default:
          card = _cardUser(user, context, () => onShowSettingFriend(user));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: card,
      );
    },
  );
}

Widget _notiNoneData(BuildContext context) {
  return Center(
    child: SizedBox(
      width: ResponsiveSizeApp(context).widthPercent(200),
      height: ResponsiveSizeApp(context).heightPercent(200),
      child: ClipRRect(child: Lottie.asset(ImagePath.lottieFriend)),
    ),
  );
}

// Card dành cho danh sách gợi ý kết bạn
Widget _cardUserSuggestion(
  VoidCallback request,
  VoidCallback remove,
  VoidCallback follow,
  BuildContext context,
  UserModel user,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: context.colorScheme.outline.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Avatar với hiệu ứng gradient border
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary.withValues(alpha: 0.3),
                  context.colorScheme.secondary.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: MyImageWidget(
                  imageUrl: user.avatarUrl ?? ImagePath.avatarDefault,
                ),
              ),
            ),
          ),

          WSpacing(12),

          // Thông tin user
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên user
                Text(
                  user.name ?? 'Unknown User',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                HSpacing(4),

                // Thông tin bạn chung và thời gian
                RichText(
                  text: TextSpan(
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: '${user.numberFriends} mutual friends',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: ' • ${formatTimeAgo(user.createdAt.toString())}',
                      ),
                    ],
                  ),
                ),

                HSpacing(12),

                // Buttons
                Observer(
                  builder: (_) {
                    final isRequested = context.friendStore.saveSentRequests
                        .contains(user.id);

                    if (isRequested) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: context.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: context.colorScheme.primary,
                            ),
                            WSpacing(4),
                            Text(
                              'Đã gửi lời mời',
                              style: TextStyle(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Row(
                      children: [
                        // Add button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: request,
                            icon: const Icon(Icons.person_add, size: 16),
                            label: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colorScheme.primary,
                              foregroundColor: context.colorScheme.onPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        WSpacing(8),

                        // Follow button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: follow,
                            icon: const Icon(Icons.favorite_border, size: 16),
                            label: const Text('Follow'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: context.colorScheme.primary,
                              side: BorderSide(
                                color: context.colorScheme.primary,
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).animate(
    type: AnimationType.fadeSlideUp,
    autoStart: true,
    curve: Curves.fastOutSlowIn,
    duration: Durations.long2,
  );
}

// Card dành cho danh sách following
Widget _cardFollowUser(
  UserModel user,
  BuildContext context,
  VoidCallback onUnfollow,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: context.colorScheme.outline.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Avatar với online indicator
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.colorScheme.primary.withValues(alpha: 0.2),
                      context.colorScheme.secondary.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: MyImageWidget(
                      imageUrl: user.avatarUrl ?? ImagePath.avatarDefault,
                    ),
                  ),
                ),
              ),

              // Following indicator
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: IconSizeApp.iconSizeSmall,
                  ),
                ),
              ),
            ],
          ),

          WSpacing(16),

          // Thông tin user
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên user với verified badge (nếu có)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name ?? 'Unknown User',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Có thể thêm verified badge ở đây nếu user được verify
                    // if (user.isVerified)
                    //   Icon(Icons.verified, size: 16, color: Colors.blue),
                  ],
                ),

                HSpacing(4),

                // Thông tin bạn chung và thời gian
                RichText(
                  text: TextSpan(
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: '${user.numberFriends} mutual friends',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            ' • Following since ${formatTimeAgo(user.createdAt.toString())}',
                      ),
                    ],
                  ),
                ),

                HSpacing(12),

                // Following status và unfollow button
                Row(
                  children: [
                    // Unfollow button
                    TextButton.icon(
                      onPressed: () {
                        // Có thể thêm confirmation dialog
                        _showUnfollowDialog(context, user, onUnfollow);
                      },
                      icon: Icon(
                        Icons.person_remove_outlined,
                        size: 16,
                        color: context.colorScheme.error,
                      ),
                      label: Text(
                        'Unfollow',
                        style: TextStyle(
                          color: context.colorScheme.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: context.colorScheme.error.withValues(
                          alpha: 0.05,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).animate(
    type: AnimationType.fadeSlideUp,
    autoStart: true,
    curve: Curves.fastOutSlowIn,
    duration: Durations.long2,
  );
}

// Card dành cho follower
Widget _cardFollower(UserModel user, BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: context.colorScheme.outline.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Avatar với online indicator
          Stack(
            children: [
              Container(
                width: ResponsiveSizeApp(context).widthPercent(60),
                height: ResponsiveSizeApp(context).heightPercent(60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.colorScheme.primary.withValues(alpha: 0.2),
                      context.colorScheme.secondary.withValues(alpha: 0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: MyImageWidget(
                      imageUrl: user.avatarUrl ?? ImagePath.avatarDefault,
                    ),
                  ),
                ),
              ),

              // Following indicator
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: ResponsiveSizeApp(context).widthPercent(20),
                  height: ResponsiveSizeApp(context).heightPercent(20),
                  decoration: BoxDecoration(
                    color: AppColor.successGreen,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.colorScheme.surface,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColor.backgroundColor,
                    size: IconSizeApp.iconSizeSmall,
                  ),
                ),
              ),
            ],
          ),

          WSpacing(16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name ?? 'Unknown User',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                HSpacing(4),

                // Thông tin bạn chung và thời gian
                RichText(
                  text: TextSpan(
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: '${user.numberFriends} mutual friends',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text:
                            ' • Following since ${formatTimeAgo(user.createdAt.toString())}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).animate(
    type: AnimationType.fadeSlideUp,
    autoStart: true,
    curve: Curves.fastOutSlowIn,
    duration: Durations.long2,
  );
}

// Hàm xác nhận
void _showUnfollowDialog(
  BuildContext context,
  UserModel user,
  VoidCallback onUnfollow,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Unfollow ${user.name}?',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You will no longer see posts from ${user.name} in your feed.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onUnfollow();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Unfollow'),
          ),
        ],
      );
    },
  );
}

// Card dành cho request từ user khác
Widget _cardUserRequest(
  VoidCallback accept,
  VoidCallback reject,
  BuildContext context,
  UserModel user,
) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: context.colorScheme.outline.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary.withValues(alpha: 0.2),
                  context.colorScheme.secondary.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.surface,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: MyImageWidget(
                  imageUrl: user.avatarUrl ?? ImagePath.avatarDefault,
                ),
              ),
            ),
          ),

          WSpacing(16),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User name
                Text(
                  user.name ?? 'Unknown User',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                HSpacing(4),

                // Mutual friends info
                RichText(
                  text: TextSpan(
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: '${user.numberFriends} mutual friends',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      TextSpan(
                        text: ' • ${formatTimeAgo(user.createdAt.toString())}',
                      ),
                    ],
                  ),
                ),

                HSpacing(12),

                // Action buttons
                Row(
                  children: [
                    // Confirm button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: accept,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          foregroundColor: context.colorScheme.onPrimary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        child: const Text('Confirm'),
                      ),
                    ),

                    WSpacing(12),

                    // Cancel button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: reject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                          side: BorderSide(
                            color: context.colorScheme.outline.withValues(
                              alpha: 0.5,
                            ),
                            width: 1,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).animate(
    type: AnimationType.fadeSlideUp,
    autoStart: true,
    curve: Curves.fastOutSlowIn,
    duration: Durations.long2,
  );
}

// Card dành cho tất cả friends
Widget _cardUser(UserModel user, BuildContext context, VoidCallback func) {
  final friendController = FriendController(
    context.friendStore,
    context.userStore,
  );

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: context.colorScheme.outline.withValues(alpha: 0.08),
        width: 1,
      ),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: func,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              context.colorScheme.primary.withValues(
                                alpha: 0.15,
                              ),
                              context.colorScheme.secondary.withValues(
                                alpha: 0.15,
                              ),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colorScheme.surface,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(26),
                            child: MyImageWidget(
                              imageUrl:
                                  user.avatarUrl ?? ImagePath.avatarDefault,
                            ),
                          ),
                        ),
                      ),

                      // Status indicator
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.colorScheme.surface,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  WSpacing(16),

                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name ?? 'User',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        HSpacing(4),

                        FutureBuilder<int>(
                          future: friendController.getMutualFriendsCountForUser(
                            user.id!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        context.colorScheme.primary.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Loading...',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                  ),
                                ],
                              );
                            }

                            final count = snapshot.data ?? 0;
                            return Row(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 14,
                                  color: context.colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  count > 0
                                      ? '$count mutual friend${count > 1 ? 's' : ''}'
                                      : 'No mutual friends',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action buttons row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => {},
                      icon: Icon(FluentIcons.chat_12_regular, size: 16),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorScheme.primary,
                        side: BorderSide(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: func,
                      icon: Icon(FluentIcons.open_12_regular, size: 16),
                      label: const Text('View Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: context.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ).animate(
    type: AnimationType.fadeSlideUp,
    autoStart: true,
    curve: Curves.fastOutSlowIn,
    duration: Durations.long2,
  );
}

Widget _directionTabBar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: ResponsiveSizeApp(context).widthPercent(40),
        height: ResponsiveSizeApp(context).heightPercent(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.mediumGrey,
        ),
      ),
    ],
  );
}

Widget _buildTabBottomSheet(
  String text,
  IconData icon,
  TabModel tab,
  bool isSelected,
  VoidCallback onTap,
) {
  return ListTile(
    onTap: onTap,
    shape: Border(
      bottom: BorderSide(
        color: AppColor.lightBlue.withValues(alpha: 0.1),
        width: 1,
      ),
    ),
    tileColor:
        isSelected
            ? AppColor.lightBlue.withValues(alpha: 0.1)
            : null, // Đổi màu nền khi được chọn
    leading: Text(
      text,
      style: TextStyle(
        fontSize: FontSizeApp.fontSizeSubMedium,
        fontWeight: FontWeight.w500,
        color: isSelected ? AppColor.lightBlue : Colors.black, // Đổi màu text
      ),
    ),
    trailing: Icon(
      icon,
      color:
          isSelected ? AppColor.lightBlue : AppColor.mediumGrey, // Đổi màu icon
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vdiary_internship/core/constants/size/size_app.dart';
import 'package:vdiary_internship/presentation/pages/auth/controller/auth_controller.dart';
import 'package:vdiary_internship/presentation/pages/chat/controller/chat_controller.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/widgets/dashboard_drawer_widget.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/widgets/logout_confirmation_dialog.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/widgets/exit_confirmation_dialog.dart';
import 'package:vdiary_internship/presentation/pages/notification/screens/notification_screen.dart';
import 'package:vdiary_internship/presentation/pages/profile/screens/profile_screen.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/controller/navigation_controller.dart';
import 'package:vdiary_internship/presentation/pages/friends/screens/my_friend_action_screen.dart';
import 'package:vdiary_internship/presentation/pages/friends/screens/my_friend_screen.dart';
import 'package:vdiary_internship/presentation/pages/home/screens/home_screen.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/shared/extensions/context_safety_extension.dart';
import 'package:vdiary_internship/presentation/themes/theme/app-color/app_color.dart';
import 'package:vdiary_internship/presentation/themes/theme/app_theme.dart';

import '../../../../data/services/shared_preferences_service.dart';
import '../../../../data/services/socket_service.dart';

class MyDashboardScreen extends StatefulWidget {
  const MyDashboardScreen({super.key});

  @override
  State<MyDashboardScreen> createState() => _MyDashboardScreenState();
}

class _MyDashboardScreenState extends State<MyDashboardScreen> {
  late final AuthController _authController;
  late final ChatController _chatController;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();

  // MobX stores
  late final NavigationStore _navigationStore;

  // Flag để tránh khởi tạo lại controllers
  bool _controllersInitialized = false;

  // Danh sách các màn hình
  final List<Widget> _screens = const [
    HomeScreen(),
    MyFriendScreen(),
    MyFriendActionScreen(),
    NotificationScreen(),
    MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _navigationStore = NavigationStore();
    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    final userId = SharedPreferencesService.getId();
    debugPrint('UserID Initialize: $userId');
    if (userId != null) {
      SocketService().connect(userId);
    }
  }

  @override
  void didChangeDependencies() {
    try {
      // Safe context access với error handling
      if (!mounted) {
        debugPrint('❌ Widget not mounted, skipping didChangeDependencies');
        return;
      }

      // Chỉ khởi tạo controllers một lần
      if (!_controllersInitialized) {
        _authController = AuthController(authStore: context.authStore);
        _chatController = ChatController(chatStore: context.chatStore);
        _controllersInitialized = true;

        // Initialize notification listeners
        final currentUserId = context.authStore.userInfo?['_id'] ?? '';
        if (currentUserId.isNotEmpty) {
          context.notificationStore.listenOwnNotifications(
            userId: currentUserId,
          );
          context.friendStore.loadFriends();
        }
      }
    } catch (e) {
      debugPrint('❌ Error in didChangeDependencies: $e');
    }

    super.didChangeDependencies();
  }

  // Hàm thay đổi index trang sử dụng MobX
  void changePage(int index) {
    _navigationStore.setCurrentPage(index);
    _sliderDrawerKey.currentState?.closeSlider();
  }

  // Handle logout with confirmation
  void _handleLogout() {
    try {
      // Context safety check
      if (!mounted || !context.mounted) {
        debugPrint('❌ Context not available for logout');
        return;
      }

      LogoutConfirmationDialog.show(context, () async {
        try {
          // Clear chat data first
          _chatController.clearMapSummaryData();

          // Then handle logout with proper context
          if (mounted && context.mounted) {
            _authController.handleLogout(context);
          }
        } catch (e) {
          debugPrint('❌ Logout callback error: $e');
        }
      });
    } catch (e) {
      debugPrint('❌ Handle logout error: $e');
    }
  }

  @override
  void dispose() {
    try {
      // Clean up resources
      debugPrint('🧹 Dashboard disposed successfully');
    } catch (e) {
      debugPrint('❌ Error disposing dashboard: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safe context access để tránh mất context
    if (!mounted || !context.isContextValid) {
      debugPrint('❌ Invalid context in build method');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final authStore = context.authStore;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Kiểm tra nếu drawer đang mở
        if (_sliderDrawerKey.currentState?.isDrawerOpen ?? false) {
          // Đóng drawer và không thoát app
          _sliderDrawerKey.currentState?.closeSlider();
          return false;
        } else {
          // Hiện dialog confirm thoát app
          ExitConfirmationDialog.show(context);
          return false; // Không thoát tự động
        }
      },
      child: Scaffold(
        body: SliderDrawer(
          key: _sliderDrawerKey,
          appBar: SliderAppBar(
            config: SliderAppBarConfig(
              // Lắng nghe trạng thái chuyển trang trên drawer
              title: Observer(
                builder:
                    (_) => Text(
                      _navigationStore.currentPageTitle,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.defaultColor,
                      ),
                    ),
              ),
              drawerIconColor: context.colorScheme.primary,
              drawerIconSize: IconSizeApp.iconSizeMedium,
              isCupertino: true,
              splashColor: Colors.transparent,
              backgroundColor: context.colorScheme.surface,
            ),
          ),
          slider: Observer(
            builder: (context) {
              if (authStore.userInfo == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return DashboardDrawerWidget(
                onPageChanged: changePage,
                currentPageIndex: _navigationStore.currentPageIndex,
                onLogout: _handleLogout,
              );
            },
          ),
          child: Observer(
            builder: (_) {
              final idx = _navigationStore.currentPageIndex;
              Widget page;
              if (idx < 0 || idx >= _screens.length) {
                page = const SizedBox.shrink();
              } else {
                page = _screens[idx];
              }
              return Scaffold(body: page);
            },
          ),
        ),
      ),
    );
  }
}

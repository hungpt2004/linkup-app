import 'package:flutter/widgets.dart';
import 'package:vdiary_internship/presentation/pages/auth/store/auth_store.dart';
import 'package:vdiary_internship/presentation/pages/chat/store/chat_store.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/store/audience_post_store.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/store/create_post_store.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/store/tag_people_post_store.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/controller/dashboard_controller.dart';
import 'package:vdiary_internship/presentation/pages/friends/store/friend_store.dart';
import 'package:vdiary_internship/presentation/pages/friends/store/user_store.dart';
import 'package:vdiary_internship/presentation/pages/home/store/network_status_checking_store.dart';
import 'package:vdiary_internship/presentation/pages/notification/store/notification_store.dart';
import 'package:vdiary_internship/presentation/pages/posts/store/deep_link_store.dart';
import 'package:vdiary_internship/presentation/pages/posts/store/post_store.dart';
import 'package:vdiary_internship/presentation/pages/profile/store/profile_post_store.dart';
import 'package:vdiary_internship/presentation/shared/store/lifecycle_store/app_lifecycle_store.dart';

class StoreProvider extends InheritedWidget {
  final AuthStore authStore;
  final DashboardController dashboardController;
  final FriendStore friendStore;
  final UserStore userStore;
  final TagUserStore tagUserStore;
  final AudienceStore audienceStore;
  final CreatePostStore createPostStore;
  final PostStore postStore;
  final ProfilePostStore profilePostStore;
  final ChatStore chatStore;
  final AppLifecycleStore appLifecycleStore;
  final DeepLinkStore deepLinkStore;
  final NotificationStore notificationStore;
  final NetworkStatusStore networkStatusStore;

  const StoreProvider({
    super.key,
    required this.audienceStore,
    required this.userStore,
    required this.authStore,
    required this.dashboardController,
    required this.friendStore,
    required this.tagUserStore,
    required this.createPostStore,
    required this.postStore,
    required this.profilePostStore,
    required this.chatStore,
    required this.appLifecycleStore,
    required this.deepLinkStore,
    required this.notificationStore,
    required this.networkStatusStore,
    required super.child,
  });

  // Trả về non-null, nếu context thiếu StoreProvider thì crash ngay
  static StoreProvider of(BuildContext context) {
    try {
      final widget =
          context.dependOnInheritedWidgetOfExactType<StoreProvider>();
      if (widget == null) {
        // Log chi tiết để debug
        debugPrint(
          '❌ StoreProvider.of() failed: widget tree không có StoreProvider',
        );
        debugPrint('Current widget: ${context.widget.runtimeType}');
        throw StateError(
          'StoreProvider chưa được wrap lên trên widget tree. Check main.dart và routing setup.',
        );
      }
      return widget;
    } catch (e) {
      debugPrint('❌ StoreProvider.of() exception: $e');
      rethrow;
    }
  }

  // Trả về nullable, nếu context thiếu StoreProvider thì trả về null
  static StoreProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StoreProvider>();
  }

  @override
  bool updateShouldNotify(StoreProvider old) =>
      authStore != old.authStore ||
      dashboardController != old.dashboardController ||
      friendStore != old.friendStore ||
      userStore != old.userStore ||
      tagUserStore != old.tagUserStore ||
      audienceStore != old.audienceStore ||
      createPostStore != old.createPostStore ||
      postStore != old.postStore ||
      chatStore != old.chatStore ||
      appLifecycleStore != old.appLifecycleStore ||
      profilePostStore != old.profilePostStore ||
      networkStatusStore != old.networkStatusStore ||
      deepLinkStore != old.deepLinkStore;
}

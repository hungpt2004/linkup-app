import 'package:flutter/cupertino.dart';
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

class StoreFactory {
  static AuthStore? _authStore;
  static DashboardController? _dashboardController;
  static FriendStore? _friendStore;
  static UserStore? _userStore;
  static TagUserStore? _tagUserStore;
  static AudienceStore? _audienceStore;
  static CreatePostStore? _createPostStore;
  static PostStore? _postStore;
  static ProfilePostStore? _profilePostStore;
  static ChatStore? _chatStore;
  static AppLifecycleStore? _lifeCycleStore;
  static DeepLinkStore? _deepLinkStore;
  static NotificationStore? _notificationStore;
  static NetworkStatusStore? _networkStatusStore;

  static NotificationStore get notificationStore {
    _notificationStore ??= NotificationStore();
    return _notificationStore!;
  }

  static NetworkStatusStore get networkStatusStore {
    _networkStatusStore ??= NetworkStatusStore();
    return _networkStatusStore!;
  }

  static AuthStore get authStore {
    _authStore ??= AuthStore();
    return _authStore!;
  }

  static DashboardController get dashboardController {
    _dashboardController ??= DashboardController();
    return _dashboardController!;
  }

  static CreatePostStore get createPostStore {
    _createPostStore ??= CreatePostStore();
    return _createPostStore!;
  }

  static PostStore get postStore {
    _postStore ??= PostStore();
    return _postStore!;
  }

  static DeepLinkStore get deepLinkStore {
    _deepLinkStore ??= DeepLinkStore();
    return _deepLinkStore!;
  }

  static FriendStore get friendStore {
    _friendStore ??= FriendStore();
    return _friendStore!;
  }

  // CHAT
  static ChatStore get chatStore {
    _chatStore ??= ChatStore();
    return _chatStore!;
  }

  // LIFE CYCLE STORE
  static AppLifecycleStore get appLifeCycleStore {
    _lifeCycleStore ??= AppLifecycleStore();
    return _lifeCycleStore!;
  }

  static UserStore get userStore {
    _userStore ??= UserStore();
    return _userStore!;
  }

  // TAG USER
  static TagUserStore get tagUserStore {
    _tagUserStore ??= TagUserStore();
    return _tagUserStore!;
  }

  static AudienceStore get audienceStore {
    _audienceStore ??= AudienceStore();
    return _audienceStore!;
  }

  static ProfilePostStore get profilePostStore {
    _profilePostStore ??= ProfilePostStore();
    return _profilePostStore!;
  }

  /// Gọi ở main() để init mọi thứ
  static Future<void> initializeAll() async {
    // DEBUG khởi tạo store factory
    debugPrint('=== STOREFACTORY INIT ===');
    debugPrint('AuthStore instance: ${authStore.hashCode}');

    // Khôi phục session
    await authStore.checkLoginStatus();

    // DEBUG SAU KHI checkLoginStatus
    debugPrint('After checkLoginStatus:');
    debugPrint('UserInfo: ${authStore.userInfo}');
    debugPrint('IsLoggedIn: ${authStore.isLoggedIn}');
    debugPrint('========================');

    try {
      final futures = <Future>[];

      // ignore: unnecessary_type_check
      if (dashboardController is DashboardController) {
        try {
          futures.add(dashboardController.initialize());
        } catch (e) {
          debugPrint(
            'Dashboard controller không có phương thức initialize(): $e',
          );
        }
      }

      // ignore: unnecessary_type_check
      if (friendStore is FriendStore) {
        try {
          futures.add(friendStore.initialize());
        } catch (e) {
          debugPrint('Friend store không có phương thức initialize(): $e');
        }
      }

      // Initialize PostStore
      // ignore: unnecessary_type_check
      if (postStore is PostStore) {
        try {
          futures.add(postStore.initialize());
        } catch (e) {
          debugPrint('Post store không có phương thức initialize(): $e');
        }
      }

      // Chờ tất cả futures hoàn thành nếu có
      if (futures.isNotEmpty) {
        await Future.wait(futures);
      }
    } catch (e) {
      debugPrint('Lỗi khởi tạo controllers: $e');
    }
  }

  static void disposeAll() {
    debugPrint('🧹 Disposing all stores...');

    try {
      // Dispose stores có cleanup methods
      _createPostStore?.dispose();

      // Reset singleton instances
      _authStore = null;
      _dashboardController = null;
      _friendStore = null;
      _userStore = null;
      _tagUserStore = null;
      _audienceStore = null;
      _createPostStore = null;
      _postStore = null;
      _profilePostStore = null;
      _chatStore = null;
      _lifeCycleStore = null;
      _deepLinkStore = null;
      _notificationStore = null;
      _networkStatusStore = null;

      debugPrint('✅ All stores disposed successfully');
    } catch (e) {
      debugPrint('❌ Error disposing stores: $e');
    }
  }

  /// Reset chỉ CreatePostStore để tránh cross-screen contamination
  static void resetCreatePostStore() {
    try {
      _createPostStore?.dispose();
      _createPostStore = null;
      debugPrint('🔄 CreatePostStore reset');
    } catch (e) {
      debugPrint('❌ Error resetting CreatePostStore: $e');
    }
  }
}

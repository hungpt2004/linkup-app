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
import 'package:vdiary_internship/presentation/shared/store/store_provider.dart';

extension StoreExt on BuildContext {
  AuthStore get authStore => StoreProvider.of(this).authStore;
  DashboardController get dashboardController =>
      StoreProvider.of(this).dashboardController;
  UserStore get userStore => StoreProvider.of(this).userStore;
  FriendStore get friendStore => StoreProvider.of(this).friendStore;
  TagUserStore get tagUserStore => StoreProvider.of(this).tagUserStore;
  AudienceStore get audienceStore => StoreProvider.of(this).audienceStore;
  CreatePostStore get createPostStore => StoreProvider.of(this).createPostStore;
  PostStore get postStore => StoreProvider.of(this).postStore;
  ProfilePostStore get profilePostStore =>
      StoreProvider.of(this).profilePostStore;
  ChatStore get chatStore => StoreProvider.of(this).chatStore;
  AppLifecycleStore get lifeCycleStore =>
      StoreProvider.of(this).appLifecycleStore;
  NotificationStore get notificationStore =>
      StoreProvider.of(this).notificationStore;
  DeepLinkStore get deepLinkStore => StoreProvider.of(this).deepLinkStore;
  NetworkStatusStore get netWorkStore =>
      StoreProvider.of(this).networkStatusStore;
}

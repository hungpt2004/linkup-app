// Use to create more direction function
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/core/constants/routes/route_name.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart'; // Import UserModel
import 'package:vdiary_internship/data/models/post/post_model.dart'; // Import PostModel

class AppNavigator {
  // Add a global navigator key for deep link navigation
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void toLogin(BuildContext context) {
    context.push(AppRouteName.signInScreen);
  }

  static void toRegister(BuildContext context) {
    context.push(AppRouteName.signUpScreen);
  }

  static void toHome(BuildContext context) {
    context.push(AppRouteName.homeScreen);
  }

  static void toDashboard(BuildContext context, {int tabIndex = 0}) {
    context.push(AppRouteName.dashboardScreen, extra: {'tabIndex': tabIndex});
  }

  static void toFormUpPost(BuildContext context) {
    context.push(AppRouteName.createPostScreen);
  }

  static void toEditImaegScreen(
    BuildContext context, {
    String mode = 'default',
  }) {
    context.push(AppRouteName.editImageScreen, extra: {'mode': mode});
  }

  static void toEditProfielScreen(BuildContext context) {
    context.push(AppRouteName.editProfileScreen);
  }

  static void toProfileScreen(BuildContext context) {
    context.push(AppRouteName.profileScreen);
  }

  // Navigate to profile detail screen
  static void toProfileDetailScreen(
    BuildContext context, {
    required UserModel user,
  }) {
    context.push(AppRouteName.profileDetailScreen, extra: user);
  }

  // Navigate to profile detail screen by user ID (fetches user data first)
  static void toProfileDetailScreenById(
    BuildContext context, {
    required String userId,
  }) {
    context.pushNamed('profileDetail', pathParameters: {'userId': userId});
  }

  static void toEditNameScreen(BuildContext context) {
    context.push(AppRouteName.editProfileNameScreen);
  }

  static void toChatBoxScreen(BuildContext context) {
    context.push(AppRouteName.chatBoxScreen);
  }

  static void toChatGroupScreen(BuildContext context) {
    context.push(AppRouteName.chatGroupScreen);
  }

  static void toChatRoomDetail(
    BuildContext context, {
    required String userId,
    required String userName,
    required String userAvatar,
    required String roomId,
  }) {
    context.push(
      AppRouteName.chatRoomDetailScreen,
      extra: {
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'roomId': roomId,
      },
    );
  }

  static void toChatRoomScreen(
    BuildContext context, {
    required String userId,
    required String name,
    required String userAvatar,
  }) {
    context.push(
      AppRouteName.chatRoomScreen,
      extra: {'userId': userId, 'name': name, 'userAvatar': userAvatar},
    );
  }

  // Navigate to post detail screen
  static void toPostDetail(BuildContext context, {required String postId}) {
    debugPrint('AppNavigator: Navigating to post detail with postId: $postId');

    // Use the new route with dynamic postId parameter for deep links
    context.pushNamed('postDetailWithId', pathParameters: {'postId': postId});
  }

  // Navigate to post detail screen with full PostModel (for regular navigation)
  static void toPostDetailWithModel(
    BuildContext context, {
    required PostModel post,
  }) {
    context.pushNamed('postDetail', extra: post);
  }

  static void pop(BuildContext context) {
    // Chỉ pop nếu có màn hình phía dưới, không pop ở các màn hình chính
    if (context.canPop()) {
      context.pop();
    } else {
      // Nếu không pop được, về dashboard mặc định
      toDashboard(context);
    }
  }

  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  // Hàm điều hướng custom cho phép truyền tham số
  // goNamed -> thay thế màn hình hiện tại
  static void goNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    context.goNamed(
      name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
      extra: extra,
    );
  }

  // pushNamed -> thêm một màn hình mới vào stack
  static void pushNamed(
    BuildContext context,
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    context.pushNamed(
      name,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  // ignore: provide_deprecation_message
  @deprecated
  static void toLoginLegacy() {
    final context = _getContext();
    if (context != null) {
      context.go(AppRouteName.signInScreen);
    }
  }

  // ignore: provide_deprecation_message
  @deprecated
  static void toHomeLegacy() {
    final context = _getContext();
    if (context != null) {
      context.go(AppRouteName.homeScreen);
    }
  }

  // Legacy context getter - only for emergency use
  static BuildContext? _getContext() {
    return WidgetsBinding.instance.focusManager.primaryFocus?.context;
  }
}

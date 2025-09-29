import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:vdiary_internship/data/services/shared_preferences_service.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';

part 'deep_link_store.g.dart';

class DeepLinkStore = _DeepLinkStoreBase with _$DeepLinkStore;

abstract class _DeepLinkStoreBase with Store {
  @observable
  String? currentDeepLink;

  @observable
  bool isProcessingLink = false;

  @observable
  String? lastError;

  @action
  void setCurrentDeepLink(String? link) {
    currentDeepLink = link;
  }

  @action
  void setIsProcessingLink(bool processing) {
    isProcessingLink = processing;
  }

  @action
  void setLastError(String? error) {
    lastError = error;
  }

  /// Handle incoming deep link
  @action
  Future<void> handleDeepLink(Uri uri) async {
    if (isProcessingLink) return;

    setIsProcessingLink(true);
    setLastError(null);
    setCurrentDeepLink(uri.toString());

    try {
      await _processDeepLink(uri);
    } catch (e) {
      setLastError(e.toString());
      debugPrint('DeepLinkStore: Error processing link: $e');
    } finally {
      setIsProcessingLink(false);
    }
  }

  /// Process the deep link and navigate to appropriate screen
  Future<void> _processDeepLink(Uri uri) async {
    final path = uri.path;
    final fragment = uri.fragment;
    final queryParameters = uri.queryParameters;

    // Wait a bit for the app to fully initialize if this is a cold start
    await Future.delayed(Duration(milliseconds: 500));

    BuildContext? context = AppNavigator.navigatorKey.currentContext;

    // Retry mechanism with multiple attempts
    int attempts = 0;
    while (context == null && attempts < 5) {
      debugPrint(
        'DeepLinkStore: No context available for navigation, attempt ${attempts + 1}/5',
      );
      await Future.delayed(
        Duration(milliseconds: 200 * (attempts + 1)),
      ); // Increasing delay
      context = AppNavigator.navigatorKey.currentContext;
      attempts++;
    }

    if (context == null) {
      debugPrint(
        'DeepLinkStore: No context available after 5 attempts, aborting navigation',
      );
      return;
    }

    final effectiveContext = context;
    debugPrint('DeepLinkStore: Using context for navigation');

    // Handle deep link for post detail
    if (path == '/post-detail' || path.startsWith('/post-detail/')) {
      debugPrint('DeepLinkStore: Matched post detail path: $path');
      // Extract postId from path or query parameters
      String? postId;
      if (path.startsWith('/post-detail/')) {
        // Extract postId from path like /post-detail/68c8e5241b3dae083a9345a6
        postId = path.substring('/post-detail/'.length);
        debugPrint('DeepLinkStore: Extracted postId from path: $postId');
      } else {
        // Extract postId from query parameters
        postId = queryParameters['postId'];
        debugPrint('DeepLinkStore: Extracted postId from query: $postId');
      }

      if (postId != null && postId.isNotEmpty && postId.trim().isNotEmpty) {
        debugPrint('DeepLinkStore: Processing postId: $postId');

        // Check if user is authenticated before navigating
        final token = SharedPreferencesService.getAccessToken();
        if (token == null || token.isEmpty) {
          debugPrint(
            'DeepLinkStore: User not authenticated, redirecting to login',
          );
          // Store the postId to navigate to after login
          await SharedPreferencesService.setPostIdToNavigate(postId);
          // Navigate to login screen first
          // ignore: use_build_context_synchronously
          AppNavigator.toLogin(effectiveContext);
          return;
        }

        // Navigate to post detail with postId
        debugPrint(
          'DeepLinkStore: Navigating to post detail with postId: $postId',
        );
        // ignore: use_build_context_synchronously
        AppNavigator.toPostDetail(effectiveContext, postId: postId);
        return;
      } else {
        debugPrint('DeepLinkStore: Invalid postId: "$postId"');
        // Navigate to dashboard if postId is invalid
        // ignore: use_build_context_synchronously
        AppNavigator.toDashboard(effectiveContext, tabIndex: 0);
        return;
      }
    }

    // Handle deep link for profile detail
    if (path.startsWith('/profile-detail/')) {
      final userId = path.substring('/profile-detail/'.length);
      if (userId.isNotEmpty) {
        // Check if user is authenticated before navigating
        final token = SharedPreferencesService.getAccessToken();
        if (token == null || token.isEmpty) {
          debugPrint(
            'DeepLinkStore: User not authenticated, redirecting to login',
          );
          // Navigate to login screen first
          // ignore: use_build_context_synchronously
          AppNavigator.toLogin(effectiveContext);
          // For now, we don't store the userId to navigate after login
          // In a real implementation, you might want to store this
          return;
        }

        AppNavigator.toProfileDetailScreenById(
          // ignore: use_build_context_synchronously
          effectiveContext,
          userId: userId,
        );
        return;
      }
    }

    // Handle deep link for profile
    if (path == '/profile-screen') {
      // ignore: use_build_context_synchronously
      AppNavigator.toProfileScreen(effectiveContext);
      return;
    }

    // Handle deep link for chat box
    if (path == '/chat-box') {
      // ignore: use_build_context_synchronously
      AppNavigator.toChatBoxScreen(effectiveContext);
      return;
    }

    // Handle deep link for dashboard
    if (path == '/dashboard') {
      // ignore: use_build_context_synchronously
      AppNavigator.toDashboard(effectiveContext, tabIndex: 0);
      return;
    }

    // Handle deep link for home
    if (path == '/home') {
      // ignore: use_build_context_synchronously
      AppNavigator.toHome(effectiveContext);
      return;
    }

    // Handle deep link for login/register
    if (path == '/login') {
      // ignore: use_build_context_synchronously
      AppNavigator.toLogin(effectiveContext);
      return;
    }
    if (path == '/register') {
      // ignore: use_build_context_synchronously
      AppNavigator.toRegister(effectiveContext);
      return;
    }

    // Handle deep link for create post
    if (path == '/form-post') {
      // ignore: use_build_context_synchronously
      AppNavigator.toFormUpPost(effectiveContext);
      return;
    }

    // Handle deep link for edit image
    if (path == '/edit-image') {
      // ignore: use_build_context_synchronously
      AppNavigator.toEditImaegScreen(effectiveContext);
      return;
    }

    // Handle deep link for edit profile
    if (path == '/edit-profile') {
      // ignore: use_build_context_synchronously
      AppNavigator.toEditProfielScreen(effectiveContext);
      return;
    }

    // Handle deep link for chat group
    if (path == '/chat-group') {
      // ignore: use_build_context_synchronously
      AppNavigator.toChatGroupScreen(effectiveContext);
      return;
    }

    // Handle deep link for fragment cases (e.g., #/post-detail?postId=123)
    if (fragment.isNotEmpty) {
      final fragmentPath = fragment.startsWith('/') ? fragment : '/$fragment';
      debugPrint('DeepLinkStore: Processing fragment: $fragmentPath');

      if (fragmentPath == '/post-detail' ||
          fragmentPath.startsWith('/post-detail/')) {
        String? postId;
        if (fragmentPath.startsWith('/post-detail/')) {
          // Extract postId from fragment path like /post-detail/68c8e5241b3dae083a9345a6
          postId = fragmentPath.substring('/post-detail/'.length);
          debugPrint(
            'DeepLinkStore: Extracted postId from fragment path: $postId',
          );
        } else {
          // Extract postId from query parameters
          postId = queryParameters['postId'];
          debugPrint(
            'DeepLinkStore: Extracted postId from fragment query: $postId',
          );
        }

        if (postId != null && postId.isNotEmpty && postId.trim().isNotEmpty) {
          debugPrint('DeepLinkStore: Navigating to post via fragment: $postId');
          // ignore: use_build_context_synchronously
          AppNavigator.toPostDetail(effectiveContext, postId: postId);
          return;
        }
      } else if (fragmentPath == '/profile-screen') {
        // ignore: use_build_context_synchronously
        AppNavigator.toProfileScreen(effectiveContext);
        return;
      } else if (fragmentPath == '/chat-box') {
        // ignore: use_build_context_synchronously
        AppNavigator.toChatBoxScreen(effectiveContext);
        return;
      }
    }

    // If there's a postId query parameter, navigate to post detail
    if (queryParameters.containsKey('postId')) {
      AppNavigator.toPostDetail(
        // ignore: use_build_context_synchronously
        effectiveContext,
        postId: queryParameters['postId']!,
      );
      return;
    }

    // If there's a screen query parameter, navigate generically
    if (queryParameters.containsKey('screen')) {
      final screen = queryParameters['screen']!;
      // ignore: use_build_context_synchronously
      _navigateToScreen(effectiveContext, screen, queryParameters);
      return;
    }

    debugPrint('DeepLinkStore: No matching route for path: $path');
  }

  /// Navigate to a specific screen with parameters
  void _navigateToScreen(
    BuildContext context,
    String screen,
    Map<String, String> params,
  ) {
    switch (screen) {
      case 'postDetail':
        if (params.containsKey('postId')) {
          AppNavigator.toPostDetail(context, postId: params['postId']!);
        }
        break;
      case 'profile':
        AppNavigator.toProfileScreen(context);
        break;
      case 'chat':
        AppNavigator.toChatBoxScreen(context);
        break;
      default:
        debugPrint('DeepLinkStore: Unknown screen: $screen');
    }
  }
}

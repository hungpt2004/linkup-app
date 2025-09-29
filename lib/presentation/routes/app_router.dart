import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vdiary_internship/core/constants/routes/route_name.dart';
import 'package:vdiary_internship/data/models/post/post_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/data/services/shared_preferences_service.dart';
import 'package:vdiary_internship/presentation/pages/auth/screens/signin_screen.dart';
import 'package:vdiary_internship/presentation/pages/auth/screens/signup_screen.dart';
import 'package:vdiary_internship/presentation/pages/chat/screens/chat_box_screen.dart';
import 'package:vdiary_internship/presentation/pages/chat/screens/chat_home_screen.dart';
import 'package:vdiary_internship/presentation/pages/chat/screens/chat_room_detail_screen.dart';
import 'package:vdiary_internship/presentation/pages/chat/screens/chat_room_screen.dart';
import 'package:vdiary_internship/presentation/pages/create-posts/screens/create_post_screen.dart';
import 'package:vdiary_internship/presentation/pages/posts/screens/post_detail_screen.dart';
import 'package:vdiary_internship/presentation/pages/profile/screens/profile_edit_name_screen.dart';
import 'package:vdiary_internship/presentation/pages/profile/screens/profile_edit_screen.dart';
import 'package:vdiary_internship/presentation/pages/home/screens/home_screen.dart';
import 'package:vdiary_internship/presentation/pages/dashboard/screens/my_dashboard_screen.dart';
import 'package:vdiary_internship/presentation/pages/posts/screens/post_images_screen.dart';
import 'package:vdiary_internship/presentation/pages/profile/screens/profile_screen.dart';
import 'package:vdiary_internship/presentation/pages/profile/screens/profile_detail_screen.dart';
import 'package:vdiary_internship/presentation/shared/extensions/store_extension.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey:
        AppNavigator.navigatorKey, // Use the navigator key from AppNavigator
    debugLogDiagnostics: true,
    initialLocation: AppRouteName.signInScreen,
    redirect: _redirect,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRouteName.signInScreen,
        name: 'signin',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const SignInScreen(),
              SlideTransitionType.slideLeft,
            ),
      ),

      // SignUp routes
      GoRoute(
        path: AppRouteName.signUpScreen,
        name: 'signup',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const SignUpScreen(),
              SlideTransitionType.slideRight,
            ),
      ),

      // Chat Room Detail
      GoRoute(
        path: AppRouteName.chatRoomDetailScreen,
        name: 'chatroomdetail',
        pageBuilder: (context, state) {
          final extra = state.extra as Map;
          final userId = extra['userId'] as String;
          final userName = extra['userName'];
          final userAvatar = extra['userAvatar'];
          final roomId = extra['roomId'];
          return _buildPageWithTransition(
            context,
            state,
            ChatRoomDetailScreen(
              userId: userId,
              userName: userName,
              userAvatar: userAvatar,
              roomId: roomId,
            ),
            SlideTransitionType.slideRight,
          );
        },
      ),

      // ChatBox routes
      GoRoute(
        path: AppRouteName.chatBoxScreen,
        name: 'chatbox',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const ChatBoxScreen(),
              SlideTransitionType.slideRight,
            ),
      ),

      // Home Routes
      GoRoute(
        path: AppRouteName.homeScreen,
        name: 'home',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const HomeScreen(),
              SlideTransitionType.fade,
            ),
      ),

      GoRoute(
        path: AppRouteName.createPostScreen,
        name: 'formpost',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              CreatePostScreen(),
              SlideTransitionType.slideUp,
            ),
      ),

      GoRoute(
        path: AppRouteName.editImageScreen,
        name: 'editimage',
        pageBuilder: (context, state) {
          final mode =
              (state.extra is Map && (state.extra as Map).containsKey('mode'))
                  ? (state.extra as Map)['mode'] as String
                  : 'default';
          return _buildPageWithTransition(
            context,
            state,
            EditImagePostScreen(mode: mode),
            SlideTransitionType.slideUp,
          );
        },
      ),

      // Edit profile
      GoRoute(
        path: AppRouteName.editProfileScreen,
        name: 'editprofile',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              EditProfileScreen(),
              SlideTransitionType.slideRight,
            ),
      ),

      // Edit name
      GoRoute(
        path: AppRouteName.editProfileNameScreen,
        name: 'editname',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              EditNameProfileScreen(),
              SlideTransitionType.slideRight,
            ),
      ),

      // Profile Screen
      GoRoute(
        path: AppRouteName.profileScreen,
        name: 'profile',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              MyProfileScreen(),
              SlideTransitionType.slideLeft,
            ),
      ),

      // Profile Detail Route
      GoRoute(
        path: '${AppRouteName.profileDetailScreen}/:userId',
        name: 'profileDetail',
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId'];
          final user = state.extra as UserModel?;

          if (user != null) {
            return _buildPageWithTransition(
              context,
              state,
              ProfileDetailScreen(user: user),
              SlideTransitionType.slideLeft,
            );
          } else if (userId != null) {
            return _buildPageWithTransition(
              context,
              state,
              ProfileDetailScreen(userId: userId),
              SlideTransitionType.slideLeft,
            );
          } else {
            // Fallback - redirect to profile screen
            return MaterialPage(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('User not found'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/profile-screen'),
                        child: Text('Go to Profile'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),

      // Dashboard Routes
      GoRoute(
        path: AppRouteName.dashboardScreen,
        name: 'dashboard',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const MyDashboardScreen(),
              SlideTransitionType.slideLeft,
            ),
      ),

      // Chat Group Routes
      GoRoute(
        path: AppRouteName.chatGroupScreen,
        name: 'chatgroup',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const ChatGroupScreen(),
              SlideTransitionType.slideRight,
            ),
      ),

      GoRoute(
        path: AppRouteName.chatRoomScreen,
        name: 'chatroom',
        pageBuilder: (context, state) {
          final extra = state.extra is Map ? state.extra as Map : {};
          final userId = extra['userId'] as String? ?? '';
          final name = extra['name'] as String? ?? '';
          final userAvatar = extra['userAvatar'] as String? ?? '';
          return _buildPageWithTransition(
            context,
            state,
            ChatRoomScreen(userId: userId, name: name, userAvatar: userAvatar),
            SlideTransitionType.slideRight,
          );
        },
      ),

      // Goto Post Detail
      GoRoute(
        path: AppRouteName.postDetailScreen,
        name: 'postDetail',
        pageBuilder: (context, state) {
          // Handle both cases: full PostModel or just postId
          final post = state.extra as PostModel?;
          final postId = state.uri.queryParameters['postId'];

          if (post != null) {
            // Traditional navigation with full post object
            return MaterialPage(child: PostDetailScreen(post: post));
          } else if (postId != null) {
            // Dynamic link navigation with just postId
            // PostDetailScreen should handle loading the post data
            return MaterialPage(child: PostDetailScreen.fromId(postId: postId));
          } else {
            // Fallback - redirect to dashboard
            return MaterialPage(
              child: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Post not found'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/dashboard'),
                        child: Text('Go to Home'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),

      // Post Detail with dynamic postId parameter (for deep links)
      GoRoute(
        path: '${AppRouteName.postDetailScreen}/:postId',
        name: 'postDetailWithId',
        pageBuilder: (context, state) {
          final postId = state.pathParameters['postId'];
          debugPrint('PostDetailWithId route: postId = $postId');

          if (postId != null && postId.isNotEmpty) {
            return MaterialPage(child: PostDetailScreen.fromId(postId: postId));
          } else {
            return MaterialPage(
              child: Scaffold(
                appBar: AppBar(title: Text('Error')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Invalid postId parameter'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/dashboard'),
                        child: Text('Go to Home'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    ],
    errorPageBuilder:
        (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: Scaffold(
            body: Center(
              child: Text('Page not found: ${state.matchedLocation}'),
            ),
          ),
        ),
  );

  // Kiểm tra xem trong local-storage có không ? Trả về trang home hoặc auth
  static Future<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final token = SharedPreferencesService.getAccessToken();
    final isAuthenticated = token != null && token.isNotEmpty;
    final authStore = context.authStore;

    debugPrint(token);

    final isLoginPage = state.matchedLocation == AppRouteName.signInScreen;

    // Có token nhưng chưa có userInfo -> load trước
    if (isAuthenticated && authStore.userInfo == null) {
      try {
        await authStore.getProfileUser();
      } catch (e) {
        // Token invalid -> clear và về login
        await SharedPreferencesService.clearAccessToken();
        return AppRouteName.signInScreen;
      }
    }

    // Đã có token và userInfo -> redirect từ login về dashboard
    if (isAuthenticated && authStore.userInfo != null && isLoginPage) {
      return AppRouteName.dashboardScreen;
    }

    return null; // Không redirect
  }

  // Hiệu ứng điều hướng
  static Page<void> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
    SlideTransitionType transitionType,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionType: transitionType,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

// Custom transition page
class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final SlideTransitionType transitionType;
  final Duration transitionDuration;

  const CustomTransitionPage({
    required this.child,
    required this.transitionType,
    this.transitionDuration = const Duration(milliseconds: 300),
    super.key,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      pageBuilder: (context, animation, _) => child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          animation,
          secondaryAnimation,
          child,
          transitionType,
        );
      },
    );
  }

  static Widget _buildTransition(
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    SlideTransitionType transitionType,
  ) {
    switch (transitionType) {
      case SlideTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case SlideTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case SlideTransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case SlideTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case SlideTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case SlideTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );

      case SlideTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
    }
  }
}

enum SlideTransitionType {
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  fade,
  scale,
  rotation,
}

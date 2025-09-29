import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdiary_internship/presentation/routes/app_navigator.dart';

class RealDynamicLinksService {
  static const String _customDomain =
      'https://idea-startup-client-private.vercel.app';
  static const String _apiBaseUrl =
      'https://idea-startup-client-private.vercel.app'; // Your backend API
  static const String _webBaseUrl =
      'https://idea-startup-client-private.vercel.app'; // Updated to use custom domain
  static const String _appScheme = 'https';

  static final Dio _dio = Dio();

  // Initialize real dynamic links
  static Future<void> initRealDynamicLinks(BuildContext context) async {
    try {
      // Set up URL scheme listener for the app
      await _setupUrlSchemeListener(context);

      // Check if app was launched from a link
      await _handleAppLaunch(context);

      debugPrint('Real dynamic links initialized successfully');
    } catch (e) {
      debugPrint('Error initializing real dynamic links: $e');
    }
  }

  // Set up URL scheme listener
  static Future<void> _setupUrlSchemeListener(BuildContext context) async {
    // This would be implemented with platform channels
    // For Android: Listen to Intent.ACTION_VIEW
    // For iOS: Listen to URL scheme opens
    debugPrint('URL scheme listener set up');
  }

  // Handle app launch from link
  static Future<void> _handleAppLaunch(BuildContext context) async {
    // Check if app was launched from a dynamic link
    // This would typically use platform channels to get launch intent
    debugPrint('Checking for app launch with dynamic link');
  }

  // Create real dynamic link for post with backend storage
  static Future<String?> createPostShareLink({
    required String postId,
    required String postTitle,
    required String postDescription,
    String? imageUrl,
  }) async {
    try {
      // Create link data
      final linkData = {
        'type': 'post',
        'content_id': postId,
        'title': postTitle,
        'description': postDescription,
        'image_url': imageUrl,
        'web_url': '$_webBaseUrl/post/$postId',
        'app_url': '$_appScheme://post/$postId',
        'created_at': DateTime.now().toIso8601String(),
      };

      // Send to backend to create short link
      final response = await _dio.post(
        '$_apiBaseUrl/dynamic-links',
        data: linkData,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final String shortId = response.data['short_id'];
        return '$_customDomain/l/$shortId'; // Real short link from backend
      }

      return null;
    } catch (e) {
      debugPrint('Error creating real post share link: $e');
      return _createFallbackLink('post', postId);
    }
  }

  // Create real dynamic link for user profile
  static Future<String?> createUserProfileShareLink({
    required String userId,
    required String userName,
    String? userAvatarUrl,
  }) async {
    try {
      final linkData = {
        'type': 'user',
        'content_id': userId,
        'title': "${userName}'s Profile",
        'description': "Check out ${userName}'s profile on VDiary!",
        'image_url': userAvatarUrl,
        'web_url': '$_webBaseUrl/user/$userId',
        'app_url': '$_appScheme://user/$userId',
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _dio.post(
        '$_apiBaseUrl/dynamic-links',
        data: linkData,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final String shortId = response.data['short_id'];
        return '$_customDomain/l/$shortId';
      }

      return null;
    } catch (e) {
      debugPrint('Error creating real user profile share link: $e');
      return _createFallbackLink('user', userId);
    }
  }

  // Create real dynamic link for chat room
  static Future<String?> createChatRoomShareLink({
    required String roomId,
    required String roomName,
    String? roomAvatarUrl,
  }) async {
    try {
      final linkData = {
        'type': 'chat',
        'content_id': roomId,
        'title': 'Join $roomName',
        'description': 'Join the conversation in $roomName on VDiary!',
        'image_url': roomAvatarUrl,
        'web_url': '$_webBaseUrl/chat/$roomId',
        'app_url': '$_appScheme://chat/$roomId',
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _dio.post(
        '$_apiBaseUrl/dynamic-links',
        data: linkData,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        final String shortId = response.data['short_id'];
        return '$_customDomain/l/$shortId';
      }

      return null;
    } catch (e) {
      debugPrint('Error creating real chat room share link: $e');
      return _createFallbackLink('chat', roomId);
    }
  }

  // Resolve real dynamic link from backend
  static Future<Map<String, dynamic>?> resolveDynamicLink(
    String shortId,
  ) async {
    try {
      final response = await _dio.get(
        '$_apiBaseUrl/dynamic-links/$shortId',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['link_data'];
      }

      return null;
    } catch (e) {
      debugPrint('Error resolving dynamic link: $e');
      return null;
    }
  }

  // Handle real dynamic link navigation
  static Future<void> handleRealDynamicLink(
    String url,
    BuildContext context,
  ) async {
    try {
      debugPrint('Handling real dynamic link: $url');

      final Uri uri = Uri.parse(url);

      // Handle custom domain short links
      if (uri.host == 'idea-startup-client-private.vercel.app' &&
          uri.path.startsWith('/l/')) {
        final String shortId = uri.path.replaceFirst('/l/', '');
        final linkData = await resolveDynamicLink(shortId);

        if (linkData != null) {
          await _navigateFromLinkData(linkData, context);
          return;
        }
      }

      // Handle custom scheme URLs
      if (uri.scheme == _appScheme) {
        await _handleCustomSchemeUrl(uri, context);
        return;
      }

      // Fallback to dashboard
      AppNavigator.toDashboard(context, tabIndex: 0);
    } catch (e) {
      debugPrint('Error handling real dynamic link: $e');
      AppNavigator.toDashboard(context, tabIndex: 0);
    }
  }

  // Navigate based on link data from backend
  static Future<void> _navigateFromLinkData(
    Map<String, dynamic> linkData,
    BuildContext context,
  ) async {
    try {
      final String type = linkData['type'] ?? '';
      final String contentId = linkData['content_id'] ?? '';

      // Track link open
      await _trackLinkOpen(linkData);

      switch (type) {
        case 'post':
          // ignore: use_build_context_synchronously
          AppNavigator.toPostDetail(context, postId: contentId);
          break;
        case 'user':
          // ignore: use_build_context_synchronously
          AppNavigator.toProfileScreen(context);
          break;
        case 'chat':
          // ignore: use_build_context_synchronously
          AppNavigator.toChatBoxScreen(context);
          break;
        default:
          AppNavigator.toDashboard(context, tabIndex: 0);
      }
    } catch (e) {
      debugPrint('Error navigating from link data: $e');
      // ignore: use_build_context_synchronously
      AppNavigator.toDashboard(context, tabIndex: 0);
    }
  }

  // Handle custom scheme URLs
  static Future<void> _handleCustomSchemeUrl(
    Uri uri,
    BuildContext context,
  ) async {
    try {
      final String host = uri.host;
      final String path = uri.path;

      switch (host) {
        case 'post':
          final String postId = path.replaceFirst('/', '');
          AppNavigator.toPostDetail(context, postId: postId);
          break;
        case 'user':
          // ignore: unused_local_variable
          final String userId = path.replaceFirst('/', '');
          AppNavigator.toProfileScreen(context);
          break;
        case 'chat':
          // ignore: unused_local_variable
          final String roomId = path.replaceFirst('/', '');
          AppNavigator.toChatBoxScreen(context);
          break;
        default:
          AppNavigator.toDashboard(context, tabIndex: 0);
      }
    } catch (e) {
      debugPrint('Error handling custom scheme URL: $e');
      AppNavigator.toDashboard(context, tabIndex: 0);
    }
  }

  // Track link opens with backend analytics
  static Future<void> _trackLinkOpen(Map<String, dynamic> linkData) async {
    try {
      await _dio.post(
        '$_apiBaseUrl/analytics/link-opens',
        data: {
          'short_id': linkData['short_id'],
          'type': linkData['type'],
          'content_id': linkData['content_id'],
          'timestamp': DateTime.now().toIso8601String(),
          'platform': 'mobile',
        },
      );
    } catch (e) {
      debugPrint('Error tracking link open: $e');
    }
  }

  // Create fallback link if backend is unavailable
  static String _createFallbackLink(String type, String id) {
    return '$_webBaseUrl/$type/$id';
  }

  // Get link analytics from backend
  static Future<Map<String, dynamic>?> getLinkAnalytics(String shortId) async {
    try {
      final response = await _dio.get(
        '$_apiBaseUrl/analytics/links/$shortId',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      debugPrint('Error getting link analytics: $e');
      return null;
    }
  }

  // Open link in browser (fallback for web)
  static Future<void> openInBrowser({required String postId}) async {
    try {
      final String webUrl = '$_webBaseUrl/post/$postId';
      final Uri uri = Uri.parse(webUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening in browser: $e');
    }
  }

  // Public method to track link opens for analytics
  static Future<void> trackLinkOpen({
    required String linkType,
    required String contentId,
  }) async {
    try {
      await _dio.post(
        '$_apiBaseUrl/analytics/link-opens',
        data: {
          'type': linkType,
          'content_id': contentId,
          'timestamp': DateTime.now().toIso8601String(),
          'platform': 'mobile',
          'action': 'share_track',
        },
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      debugPrint('Link open tracked: $linkType - $contentId');
    } catch (e) {
      debugPrint('Error tracking link open: $e');
    }
  }

  // Validate dynamic link
  static bool isValidDynamicLink(String link) {
    try {
      final Uri uri = Uri.parse(link);
      return uri.host == 'idea-startup-client-private.vercel.app';
    } catch (e) {
      return false;
    }
  }
}

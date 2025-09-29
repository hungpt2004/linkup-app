import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/data/services/lifecycle_service.dart';
import 'package:vdiary_internship/data/services/local_notification_service.dart';
import 'package:vdiary_internship/presentation/pages/chat/service/chat-firebase-service/presence_service.dart';
import 'package:vdiary_internship/presentation/shared/widgets/toast_message/toast_widget.dart';

import '../extensions/store_extension.dart';
import '../store/lifecycle_store/app_lifecycle_store.dart';

class LifecycleObserverWidget extends StatefulWidget {
  final Widget child;

  const LifecycleObserverWidget({super.key, required this.child});

  @override
  State<LifecycleObserverWidget> createState() =>
      _LifecycleObserverWidgetState();
}

class _LifecycleObserverWidgetState extends State<LifecycleObserverWidget>
    with WidgetsBindingObserver {
  late LifecycleService _lifecycleService;
  ReactionDisposer? _networkReaction;
  bool _isFirstCheck = true;
  bool _previousIsConnected = false;
  bool _previousIsWifi = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lifecycleService = LifecycleService(context: context);

    // Dispose reaction cũ (nếu có) để tránh leak
    _networkReaction?.call();

    // Tạo reaction để lắng nghe networkStatus thay đổi
    final netWorkStore = context.netWorkStore;
    debugPrint('Setting up network reaction');
    debugPrint(
      'Initial network state - Connected: ${netWorkStore.isConnected}, WiFi: ${netWorkStore.isWifi}',
    );

    _networkReaction = reaction(
      (_) => {
        'connected': netWorkStore.isConnected,
        'wifi': netWorkStore.isWifi,
      },
      (networkStatus) {
        debugPrint('Network reaction triggered');
        debugPrint('Network status: $networkStatus');

        // Skip the first check to avoid showing toast on initial load
        if (_isFirstCheck) {
          _isFirstCheck = false;
          _previousIsConnected = networkStatus['connected'] as bool;
          _previousIsWifi = networkStatus['wifi'] as bool;
          debugPrint(
            "Initial network state - Connected: ${networkStatus['connected']}, WiFi: ${networkStatus['wifi']}",
          );
          NotificationService().showNotification(
            '"Initial network state - Connected: ${networkStatus['connected']}, WiFi: ${networkStatus['wifi']}"',
          );
          return;
        }

        if (!mounted) return;

        final bool isConnected = networkStatus['connected'] as bool;
        final bool isWifi = networkStatus['wifi'] as bool;

        debugPrint(
          "Network status changed - Connected: $isConnected, WiFi: $isWifi",
        );

        // Handle connection status changes
        if (isConnected != _previousIsConnected) {
          if (isConnected) {
            // Check if it's WiFi or mobile data
            if (isWifi) {
              debugPrint("Connected to WiFi");
              ToastAppWidget.showSuccessToast(context, 'Connect Wifi Success');
              // Post queued posts when WiFi becomes available
              _postQueuedPosts();
            } else {
              debugPrint("Connected to Mobile Data");
              ToastAppWidget.showSuccessToast(
                context,
                'Connect Mobile Data Success',
              );
            }
          } else {
            debugPrint("No Internet Connection");
            ToastAppWidget.showErrorToast(context, 'No Internet Connection');
          }
        }
        // Handle WiFi status changes when connected
        else if (isConnected && isWifi != _previousIsWifi) {
          if (isWifi) {
            debugPrint("Switched to WiFi");
            ToastAppWidget.showSuccessToast(context, 'Switched to Wifi');
            // Post queued posts when switching to WiFi
            _postQueuedPosts();
          } else {
            debugPrint("Switched to Mobile Data");
            ToastAppWidget.showSuccessToast(context, 'Switched to Mobile Data');
          }
        }

        // Update previous states
        _previousIsConnected = isConnected;
        _previousIsWifi = isWifi;
      },
    );
  }

  // Method to post queued posts when WiFi becomes available
  void _postQueuedPosts() {
    // Access the CreatePostStore to post queued posts
    final createPostStore = context.createPostStore;
    // ignore: unnecessary_null_comparison
    if (createPostStore != null) {
      debugPrint('PostNeedWifi length: ${createPostStore.postNeedWifi.length}');
      if (createPostStore.postNeedWifi.isNotEmpty) {
        debugPrint(
          'Attempting to post ${createPostStore.postNeedWifi.length} queued posts',
        );
        createPostStore.postQueuedPostsWhenOnline();
      } else {
        debugPrint('No queued posts to post');
      }
    } else {
      debugPrint('CreatePostStore is null');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _networkReaction?.call();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final userId = context.authStore.userInfo?['_id'];
    if (userId == null) return;

    final lifeCycleStatus = context.lifeCycleStore;
    if (state == AppLifecycleState.inactive) {
      _lifecycleService.onBackground();
      lifeCycleStatus.status =
          AppLifecycleStatus.background; // sửa = thay vì ==
      PresenceService().setOfflineStatus(userId);
    } else if (state == AppLifecycleState.resumed) {
      _lifecycleService.onForeground();
      lifeCycleStatus.status = AppLifecycleStatus.foreground;
      PresenceService().setupPresence(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Không cần Observer nữa, chỉ return child
    return widget.child;
  }
}

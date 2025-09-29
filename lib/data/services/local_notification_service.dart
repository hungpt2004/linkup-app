import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Khởi tạo
  Future<void> init() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await _requestAndroidPermission();
  }

  // Xin quyền POST_NOTIFICATIONS (Android 13+)
  Future<void> _requestAndroidPermission() async {
    final androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.requestNotificationsPermission();
  }

  // Hàm show notification
  Future<void> showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'lifecycle_channel',
      'Lifecycle Notifications',
      channelDescription: 'Thông báo khi app đổi trạng thái',
      importance: Importance.max,
      priority: Priority.high,
      silent: true,
      playSound: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Trạng thái ứng dụng',
      message,
      notificationDetails,
    );
  }
}

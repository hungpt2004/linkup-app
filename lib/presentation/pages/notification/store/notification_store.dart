import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:vdiary_internship/data/models/notification/notification_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/data/services/firebase_notification_service.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';

part 'notification_store.g.dart';

class NotificationStore = _NotificationStore with _$NotificationStore;

abstract class _NotificationStore with Store {
  final FirebaseNotificationService _service = FirebaseNotificationService();

  StreamSubscription<List<NotificationModel>>? _ownSub;
  StreamSubscription<List<NotificationModel>>? _logSub;

  @observable
  ObservableList<NotificationModel> ownNotifications = ObservableList();

  @observable
  ObservableList<NotificationModel> logActivities = ObservableList();

  @observable
  bool isLoading = false;

  @computed
  int get unreadNotificationCount =>
      ownNotifications.where((notification) => !notification.isRead).length;

  @action
  Future<String> createNotification({
    String? referenceId,
    required UserEntity authorInformation,
    required List<UserModel> friends,
    required String actionAuthorId,
    required String contentNotification,
    required String typeNotification,
    required String deepLink,
  }) async {
    isLoading = true;
    try {
      return await _service.createNotification(
        referenceId,
        friends,
        authorInformation: authorInformation,
        actionAuthorId: actionAuthorId,
        contentNotification: contentNotification,
        typeNotification: typeNotification,
        deepLink: deepLink,
      );
    } finally {
      isLoading = false;
    }
  }

  @action
  void listenOwnNotifications({required String userId, String? type}) {
    _ownSub?.cancel();
    _ownSub = _service
        .getOwnNotification(authorId: userId, typeNotification: type)
        .listen((data) {
          // Có thể filter/sort trước khi gán
          data.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          ownNotifications = ObservableList.of(data);

          // Debug print to see what's happening
          debugPrint('Total notifications: ${data.length}');
          debugPrint('Unread notifications: $unreadNotificationCount');
          for (var i = 0; i < data.length; i++) {
            debugPrint('Notification $i: isRead = ${data[i].isRead}');
          }
        }, onError: (error) {
          debugPrint('Error listening to own notifications: $error');
        });
  }

  @action
  void listenLogActivities({required String userId, String? type}) {
    _logSub?.cancel();
    _logSub = _service
        .getLogActivity(authorId: userId, typeNotification: type)
        .listen((data) {
          logActivities = ObservableList.of(data);
        }, onError: (error) {
          debugPrint('Error listening to log activities: $error');
        });
  }

  void dispose() {
    _ownSub?.cancel();
    _logSub?.cancel();
  }
}
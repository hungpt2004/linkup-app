import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:vdiary_internship/core/constants/routes/firestore_path.dart';
import 'package:vdiary_internship/data/models/notification/notification_model.dart';
import 'package:vdiary_internship/data/models/user/user_model.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';
import 'package:vdiary_internship/presentation/shared/store/firebase-database-provider/firebase_store_singleton.dart';

class FirebaseNotificationService {
  final _db = FirebaseFirestoreProvider().instance;

  /// Tạo mới notification
  Future<String> createNotification(
    String? referenceId,
    List<UserModel>? friendLists, {
    required UserEntity authorInformation,
    required String actionAuthorId,
    required String contentNotification,
    required String typeNotification,
    required String deepLink,
  }) async {
    try {
      final doc = _db.collection(FireStoreCollection.notification).doc();

      final notification = NotificationModel(
        authorInformation: authorInformation,
        referenceId: referenceId ?? '',
        notificationId: doc.id,
        actionAuthorId: actionAuthorId,
        receiveUserIds: getFriendIds(friendLists ?? [], actionAuthorId),
        typeNotification: typeNotification,
        contentNotification: contentNotification,
        deepLink: deepLink,
        createdAt: Timestamp.now(),
      );

      await doc.set(notification.toMap());
      debugPrint('Notification created with ID: ${doc.id}');
      return doc.id;
    } catch (e) {
      debugPrint('Error creating notification: $e');
      rethrow;
    }
  }

  /// Lấy stream các notification theo user + optional type
  Stream<List<NotificationModel>> getLogActivity({
    required String authorId,
    String? typeNotification,
  }) {
    try {
      Query<Map<String, dynamic>> query = _db
          .collection(FireStoreCollection.notification)
          .where("actionAuthorId", isEqualTo: authorId);

      if (typeNotification != null && typeNotification.isNotEmpty) {
        query = query.where("typeNotification", isEqualTo: typeNotification);
      }

      return query.snapshots().map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data()))
              .toList();
        } catch (e) {
          debugPrint('Error parsing log activity notifications: $e');
          return <NotificationModel>[];
        }
      });
    } catch (e) {
      debugPrint('Error getting log activity stream: $e');
      return Stream.value(<NotificationModel>[]);
    }
  }

  // Lấy arr friend ids
  List<String> getFriendIds(List<UserModel> friendLists, String authorId) {
    if (friendLists.isEmpty) return [];
    return friendLists
        .map((item) => item.id ?? '')
        .where((id) => id.isNotEmpty && id != authorId) // Exclude the author
        .toList();
  }

  // Get own notification
  Stream<List<NotificationModel>> getOwnNotification({
    required String authorId,
    String? typeNotification,
  }) {
    try {
      Query<Map<String, dynamic>> query = _db
          .collection(FireStoreCollection.notification)
          .where("receiveUserIds", arrayContains: authorId);

      if (typeNotification != null && typeNotification.isNotEmpty) {
        query = query.where("typeNotification", isEqualTo: typeNotification);
      }

      return query.snapshots().map((snapshot) {
        try {
          final notifications =
              snapshot.docs
                  .map((doc) => NotificationModel.fromMap(doc.data()))
                  .toList();

          debugPrint(
            'Retrieved ${notifications.length} notifications for user $authorId',
          );
          return notifications;
        } catch (e) {
          debugPrint('Error parsing own notifications: $e');
          return <NotificationModel>[];
        }
      });
    } catch (e) {
      debugPrint('Error getting own notification stream: $e');
      return Stream.value(<NotificationModel>[]);
    }
  }

  // Đánh dấu thông báo đã đọc
  Future<void> updateReadNotification(String notificationId) async {
    final doc = _db
        .collection(FireStoreCollection.notification)
        .doc(notificationId);
    await doc.update({'isRead': true});
  }
}

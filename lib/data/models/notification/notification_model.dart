import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vdiary_internship/domain/entities/user_entity.dart';

class NotificationModel {
  final String notificationId;
  final String actionAuthorId;
  final UserEntity authorInformation;
  final List<String> receiveUserIds; // <-- đổi thành List<String>
  final String? referenceId; // có thể là id của bất kỳ cái nào
  final String contentNotification;
  final String typeNotification;
  final bool isRead;
  final String deepLink;
  final Timestamp createdAt;

  NotificationModel({
    required this.notificationId,
    required this.actionAuthorId,
    required this.authorInformation,
    required this.receiveUserIds,
    this.referenceId,
    required this.contentNotification,
    required this.typeNotification,
    this.isRead = false,
    required this.deepLink,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "notificationId": notificationId,
      "actionAuthorId": actionAuthorId,
      "authorInformation": authorInformation.toMap(),
      "receiveUserIds": receiveUserIds, // lưu mảng
      "referenceId": referenceId,
      "contentNotification": contentNotification,
      "typeNotification": typeNotification,
      "isRead": isRead,
      "deepLink": deepLink,
      "createdAt": createdAt,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notificationId: map['notificationId'],
      actionAuthorId: map['actionAuthorId'],
      receiveUserIds: List<String>.from(map['receiveUserIds'] ?? []),
      referenceId: map['referenceId'],
      contentNotification: map['contentNotification'],
      typeNotification: map['typeNotification'],
      isRead: map['isRead'] ?? false,
      deepLink: map['deepLink'] ?? '',
      createdAt:
          map['createdAt'] is Timestamp
              ? map['createdAt']
              : Timestamp.fromMillisecondsSinceEpoch(
                map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
              ),
      authorInformation: UserEntity.fromMap(
        Map<String, dynamic>.from(map['authorInformation'] ?? {}),
      ),
    );
  }
}

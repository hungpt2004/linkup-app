import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_status_model.dart';

class Message {
  final String messageId;
  final String senderId;
  final String type; // text | image | system
  final String? text;
  final List<String>? images;
  final Timestamp createdAt;
  final bool isDeleted;
  final MessageStatus status;

  Message({
    required this.messageId,
    required this.senderId,
    required this.type,
    this.text,
    required this.images,
    required this.createdAt,
    this.isDeleted = false,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "senderId": senderId,
      "type": type,
      "text": text,
      "images": images,
      "createdAt": createdAt,
      "isDeleted": isDeleted,
      "status": status.toMap(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map["messageId"] ?? "",
      senderId: map["senderId"] ?? "",
      type: map["type"] ?? "text",
      text: map["text"],
      images: List<String>.from(map["images"] ?? []),
      createdAt:
          map["createdAt"] is Timestamp
              ? map["createdAt"]
              : Timestamp.fromMillisecondsSinceEpoch(
                map["createdAt"] ?? DateTime.now().millisecondsSinceEpoch,
              ),
      isDeleted: map['isDeleted'] ?? false,
      status: MessageStatus.fromMap(
        Map<String, dynamic>.from(map["status"] ?? {}),
      ),
    );
  }
}

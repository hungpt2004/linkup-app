import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMember {
  final String userId;
  final String role; // member | admin
  final String? lastSeenMessageId;
  final Timestamp joinedAt;

  ChatMember({
    required this.userId,
    required this.role,
    this.lastSeenMessageId,
    required this.joinedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "role": role,
      "lastSeenMessageId": lastSeenMessageId,
      "joinedAt": joinedAt,
    };
  }

  factory ChatMember.fromMap(Map<String, dynamic> map) {
    return ChatMember(
      userId: map["userId"] ?? "",
      role: map["role"] ?? "member",
      lastSeenMessageId: map["lastSeenMessageId"] ?? '',
      joinedAt: map["joinedAt"] ?? Timestamp.now(),
    );
  }
}

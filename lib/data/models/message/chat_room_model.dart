import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_member_model.dart';

class ChatRoom {
  final String roomId;
  final String type; // private | group
  final String? name;
  final String? avatarUrl;
  final List<ChatMember> members;
  final List<String> memberIds;
  final Map<String, dynamic>? lastMessage;
  final Timestamp createdAt;
  final String createdBy;

  ChatRoom({
    required this.roomId,
    required this.type,
    this.name,
    this.avatarUrl,
    required this.members,
    required this.memberIds,
    this.lastMessage,
    required this.createdAt,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      "roomId": roomId,
      "type": type,
      "name": name,
      "avatarUrl": avatarUrl,
      "members": members.map((m) => m.toMap()).toList(),
      "lastMessage": lastMessage,
      "createdAt": createdAt,
      "createdBy": createdBy,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      roomId: map["roomId"] ?? "",
      type: map["type"] ?? "private",
      name: map["name"],
      avatarUrl: map["avatarUrl"],
      members:
          (map["members"] as List)
              .map((m) => ChatMember.fromMap(Map<String, dynamic>.from(m)))
              .toList(),
      memberIds: map['membersIds'] ?? [],
      lastMessage: map["lastMessage"],
      createdAt: map["createdAt"] ?? Timestamp.now(),
      createdBy: map["createdBy"] ?? "",
    );
  }
}

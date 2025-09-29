import 'package:hive/hive.dart';
import 'chat_member_model_hive.dart';

part 'chat_room_model_hive.g.dart';

@HiveType(typeId: 21)
class ChatRoomModelHive {
  @HiveField(0)
  final String roomId;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? avatarUrl;

  @HiveField(4)
  final List<ChatMemberModelHive> members;

  @HiveField(5)
  final List<String> memberIds;

  @HiveField(6)
  final Map<String, dynamic>? lastMessage;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final String createdBy;

  ChatRoomModelHive({
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
}

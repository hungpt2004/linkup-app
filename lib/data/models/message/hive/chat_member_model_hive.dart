import 'package:hive/hive.dart';

part 'chat_member_model_hive.g.dart';

@HiveType(typeId: 20)
class ChatMemberModelHive {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String role;

  @HiveField(2)
  final String? lastSeenMessageId;

  @HiveField(3)
  final DateTime joinedAt;

  ChatMemberModelHive({
    required this.userId,
    required this.role,
    this.lastSeenMessageId,
    required this.joinedAt,
  });
}

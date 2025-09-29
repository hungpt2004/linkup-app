import 'package:hive/hive.dart';
import 'message_status_model_hive.dart';

part 'message_model_hive.g.dart';

@HiveType(typeId: 22)
class MessageModelHive {
  @HiveField(0)
  final String messageId;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String? text;

  @HiveField(4)
  final List<String>? images;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final bool isDeleted;

  @HiveField(7)
  final MessageStatusModelHive status;

  MessageModelHive({
    required this.messageId,
    required this.senderId,
    required this.type,
    this.text,
    required this.images,
    required this.createdAt,
    this.isDeleted = false,
    required this.status,
  });
}

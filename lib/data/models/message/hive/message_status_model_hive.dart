import 'package:hive/hive.dart';

part 'message_status_model_hive.g.dart';

@HiveType(typeId: 23)
class MessageStatusModelHive {
  @HiveField(0)
  final List<Map<String, dynamic>> deliveredTo;

  @HiveField(1)
  final List<Map<String, dynamic>> readBy;

  MessageStatusModelHive({required this.deliveredTo, required this.readBy});
}

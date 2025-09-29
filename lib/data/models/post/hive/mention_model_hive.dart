import 'package:hive/hive.dart';

part 'mention_model_hive.g.dart';

@HiveType(typeId: 5)
class MentionModelHive {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? avatar;

  MentionModelHive({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });
}
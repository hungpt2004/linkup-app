import 'package:hive/hive.dart';

part 'hashtag_model_hive.g.dart';

@HiveType(typeId: 6)
class HashtagModelHive {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;

  HashtagModelHive({
    required this.id, 
    required this.name
  });
}
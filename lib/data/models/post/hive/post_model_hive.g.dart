// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostModelHiveAdapter extends TypeAdapter<PostModelHive> {
  @override
  final int typeId = 0;

  @override
  PostModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostModelHive(
      id: fields[0] as String,
      caption: fields[1] as String,
      images: (fields[2] as List).cast<String>(),
      videos: (fields[3] as List).cast<String>(),
      links: (fields[4] as List).cast<LinkModelHive>(),
      author: fields[5] as String,
      hashtags: (fields[6] as List).cast<HashtagModelHive>(),
      mentions: (fields[7] as List).cast<MentionModelHive>(),
      listUsers: (fields[8] as List).cast<LikeModelHive>(),
      likeCount: fields[9] as int,
      privacy: fields[10] as String,
      comments: fields[11] as int,
      user: fields[12] as UserModelHive,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PostModelHive obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.caption)
      ..writeByte(2)
      ..write(obj.images)
      ..writeByte(3)
      ..write(obj.videos)
      ..writeByte(4)
      ..write(obj.links)
      ..writeByte(5)
      ..write(obj.author)
      ..writeByte(6)
      ..write(obj.hashtags)
      ..writeByte(7)
      ..write(obj.mentions)
      ..writeByte(8)
      ..write(obj.listUsers)
      ..writeByte(9)
      ..write(obj.likeCount)
      ..writeByte(10)
      ..write(obj.privacy)
      ..writeByte(11)
      ..write(obj.comments)
      ..writeByte(12)
      ..write(obj.user)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

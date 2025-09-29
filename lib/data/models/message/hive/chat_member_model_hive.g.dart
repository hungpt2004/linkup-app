// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_member_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMemberModelHiveAdapter extends TypeAdapter<ChatMemberModelHive> {
  @override
  final int typeId = 20;

  @override
  ChatMemberModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMemberModelHive(
      userId: fields[0] as String,
      role: fields[1] as String,
      lastSeenMessageId: fields[2] as String?,
      joinedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMemberModelHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.lastSeenMessageId)
      ..writeByte(3)
      ..write(obj.joinedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMemberModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

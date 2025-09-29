// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatRoomModelHiveAdapter extends TypeAdapter<ChatRoomModelHive> {
  @override
  final int typeId = 21;

  @override
  ChatRoomModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatRoomModelHive(
      roomId: fields[0] as String,
      type: fields[1] as String,
      name: fields[2] as String?,
      avatarUrl: fields[3] as String?,
      members: (fields[4] as List).cast<ChatMemberModelHive>(),
      memberIds: (fields[5] as List).cast<String>(),
      lastMessage: (fields[6] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[7] as DateTime,
      createdBy: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoomModelHive obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.roomId)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.members)
      ..writeByte(5)
      ..write(obj.memberIds)
      ..writeByte(6)
      ..write(obj.lastMessage)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.createdBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

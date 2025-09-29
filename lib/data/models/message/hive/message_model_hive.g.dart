// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageModelHiveAdapter extends TypeAdapter<MessageModelHive> {
  @override
  final int typeId = 22;

  @override
  MessageModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageModelHive(
      messageId: fields[0] as String,
      senderId: fields[1] as String,
      type: fields[2] as String,
      text: fields[3] as String?,
      images: (fields[4] as List?)?.cast<String>(),
      createdAt: fields[5] as DateTime,
      isDeleted: fields[6] as bool,
      status: fields[7] as MessageStatusModelHive,
    );
  }

  @override
  void write(BinaryWriter writer, MessageModelHive obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.text)
      ..writeByte(4)
      ..write(obj.images)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isDeleted)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

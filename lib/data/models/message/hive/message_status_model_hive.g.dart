// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_status_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageStatusModelHiveAdapter
    extends TypeAdapter<MessageStatusModelHive> {
  @override
  final int typeId = 23;

  @override
  MessageStatusModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageStatusModelHive(
      deliveredTo: (fields[0] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      readBy: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, MessageStatusModelHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.deliveredTo)
      ..writeByte(1)
      ..write(obj.readBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatusModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

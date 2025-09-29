// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MentionModelHiveAdapter extends TypeAdapter<MentionModelHive> {
  @override
  final int typeId = 5;

  @override
  MentionModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MentionModelHive(
      id: fields[0] as String,
      name: fields[2] as String,
      email: fields[1] as String,
      avatar: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MentionModelHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MentionModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

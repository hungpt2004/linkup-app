// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'like_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LikeModelHiveAdapter extends TypeAdapter<LikeModelHive> {
  @override
  final int typeId = 3;

  @override
  LikeModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LikeModelHive(
      id: fields[0] as String,
      typeReact: fields[1] as String,
      user: fields[2] as UserModelHive,
    );
  }

  @override
  void write(BinaryWriter writer, LikeModelHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.typeReact)
      ..writeByte(2)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LikeModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

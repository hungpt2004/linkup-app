// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelHiveAdapter extends TypeAdapter<UserModelHive> {
  @override
  final int typeId = 2;

  @override
  UserModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModelHive(
      id: fields[0] as String?,
      email: fields[1] as String?,
      name: fields[2] as String?,
      verified: fields[3] as bool,
      role: fields[4] as UserRoleHive,
      avatarUrl: fields[5] as String?,
      numberFriends: fields[6] as int,
      coverImageUrl: fields[7] as String?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModelHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.verified)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.avatarUrl)
      ..writeByte(6)
      ..write(obj.numberFriends)
      ..writeByte(7)
      ..write(obj.coverImageUrl)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRoleHiveAdapter extends TypeAdapter<UserRoleHive> {
  @override
  final int typeId = 1;

  @override
  UserRoleHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRoleHive.admin;
      case 1:
        return UserRoleHive.user;
      default:
        return UserRoleHive.admin;
    }
  }

  @override
  void write(BinaryWriter writer, UserRoleHive obj) {
    switch (obj) {
      case UserRoleHive.admin:
        writer.writeByte(0);
        break;
      case UserRoleHive.user:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

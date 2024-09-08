// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataImplAdapter extends TypeAdapter<_$UserDataImpl> {
  @override
  final int typeId = 1;

  @override
  _$UserDataImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$UserDataImpl(
      id: fields[0] as String,
      email: fields[1] as String,
      role: fields[2] as String,
      status: fields[3] as String,
      points: fields[4] as int,
      referredBy: fields[5] as String?,
      referralId: fields[6] as int,
      walletId: fields[7] as int,
      profileImageUrl: fields[8] as String?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      referralCode: fields[11] as String,
      accountAddress: fields[12] as String,
      sessionId: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, _$UserDataImpl obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.points)
      ..writeByte(5)
      ..write(obj.referredBy)
      ..writeByte(6)
      ..write(obj.referralId)
      ..writeByte(7)
      ..write(obj.walletId)
      ..writeByte(8)
      ..write(obj.profileImageUrl)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.referralCode)
      ..writeByte(12)
      ..write(obj.accountAddress)
      ..writeByte(13)
      ..write(obj.sessionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      points: (json['points'] as num).toInt(),
      referredBy: json['referredBy'] as String?,
      referralId: (json['referralId'] as num).toInt(),
      walletId: (json['walletId'] as num).toInt(),
      profileImageUrl: json['profileImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      referralCode: json['referralCode'] as String,
      accountAddress: json['accountAddress'] as String,
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'points': instance.points,
      'referredBy': instance.referredBy,
      'referralId': instance.referralId,
      'walletId': instance.walletId,
      'profileImageUrl': instance.profileImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'referralCode': instance.referralCode,
      'accountAddress': instance.accountAddress,
      'sessionId': instance.sessionId,
    };

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';
part 'user.freezed.dart';

@freezed
class UserData extends HiveObject with _$UserData {
  UserData._();

  @HiveType(typeId: 1)
  factory UserData({
    @HiveField(0) required String id,
    @HiveField(1) required String phoneNumber,
    @HiveField(2) required String username,
    @HiveField(3) required String nickname,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) required DateTime updatedAt,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

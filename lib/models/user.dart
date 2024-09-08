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
    @HiveField(1) required String email,
    @HiveField(2) required String role,
    @HiveField(3) required String status,
    @HiveField(4) required int points,
    @HiveField(5) required String? referredBy,
    @HiveField(6) required int referralId,
    @HiveField(7) required int walletId,
    @HiveField(8) required String? profileImageUrl,
    @HiveField(9) required DateTime createdAt,
    @HiveField(10) required DateTime updatedAt,
    @HiveField(11) required String referralCode,
    @HiveField(12) required String accountAddress,
    @HiveField(13) required String sessionId,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

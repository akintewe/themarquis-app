import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:marquis_v2/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "user.g.dart";

@Riverpod(keepAlive: true)
class User extends _$User {
  //Details Declaration
  Box<UserData>? _hiveBox;

  @override
  UserData? build() {
    _hiveBox ??= Hive.box<UserData>("user");
    return _hiveBox!.get("user");
  }

  Future<void> getUser() async {
    // final user = await ref
    //     .read(natsServiceProvider.notifier)
    //     .makeMicroserviceRequest<UserData>(
    //   "jomfi.getUser.<user>",
    //   jsonEncode({
    //     "companyRegNo": "",
    //     "auth": "",
    //   }),
    //   jsonDecoder: (p0) {
    //     final json = jsonDecode(p0);
    //     return UserData.fromJson(json);
    //   },
    // );
    // await ref.read(changesProvider.notifier).getChanges();
    final user = UserData(
        id: "id",
        phoneNumber: "+60123456789",
        username: "wms2537",
        nickname: "WMS",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    await _hiveBox!.put("user", user);
    state = user;
  }

  Future<void> clearData() async {
    _hiveBox!.delete("user");
    state = null;
  }

  Future<void> editUser(
    String firstName,
    String lastName,
    DateTime birthdate,
    String gender,
    String country,
    String fieldOfCareer,
  ) async {
    // await ref.read(natsServiceProvider.notifier).makeMicroserviceRequest(
    //       "jomfi.editUser.<user>",
    //       jsonEncode({
    //         'firstName': firstName,
    //         'lastName': lastName,
    //         'birthdate': birthdate.toIso8601String(),
    //         'gender': gender,
    //         'country': country,
    //         'fieldOfCareer': fieldOfCareer,
    //       }),
    //     );
    // state = state?.copyWith(
    //   firstName: firstName,
    //   lastName: lastName,
    //   birthdate: birthdate,
    //   gender: gender,
    //   country: country,
    //   fieldOfCareer: fieldOfCareer,
    // );
  }
}

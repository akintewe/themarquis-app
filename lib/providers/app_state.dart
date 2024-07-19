import 'dart:async';

import 'package:marquis_v2/models/app_state.dart';
import 'package:hive/hive.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "app_state.g.dart";

@Riverpod(keepAlive: true)
class AppState extends _$AppState {
  Box<AppStateData>? _hiveBox;
  Timer? _refreshTokenTimer;
  @override
  AppStateData build() {
    _hiveBox ??= Hive.box<AppStateData>("appState");
    final result = _hiveBox!.get("appState", defaultValue: AppStateData())!;
    return result.copyWith(autoLoginResult: null);
  }

  void changeNavigatorIndex(int newIndex) {
    state = state.copyWith(navigatorIndex: newIndex);
    _hiveBox!.put("appState", state);
  }

  void changeTheme(String theme) {
    state = state.copyWith(theme: theme);
    _hiveBox!.put("appState", state);
  }

  void selectGame(String? id) {
    state = state.copyWith(
      selectedGame: id,
    );
    _hiveBox!.put("appState", state);
  }

  Future<void> login(String token) async {
    state = state.copyWith(token: token, autoLoginResult: true);
    await _hiveBox!.put("appState", state);
  }

  Future<void> loginWithGoogle(String idToken) async {
    // final response =
    //     await ref.read(natsServiceProvider.notifier).makeMicroserviceRequest(
    //           "auth.login",
    //           jsonEncode({
    //             "method": "google",
    //             "id": "",
    //             "token": idToken,
    //             "service": "beautifood",
    //             "device": await Utils.getDeviceInfo(),
    //             "deviceType": kIsWeb
    //                 ? "web"
    //                 : Platform.isIOS
    //                     ? "ios"
    //                     : "android",
    //           }),
    //           isAuth: true,
    //         );
    // final json = jsonDecode(response) as Map<String, dynamic>;
    // final token = Token.fromJson(json["token"]);
    // final creds = json["creds"];
    // await ref
    //     .read(natsServiceProvider.notifier)
    //     .updateConnection(creds, token.user);

    // _refreshTokenTimer = Timer(
    //   token.accessTokenExpiry.difference(
    //     DateTime.now(),
    //   ),
    //   () {
    //     refreshToken();
    //   },
    // );
    // state = state.copyWith(token: token, autoLoginResult: true);
    // await _hiveBox!.put("appState", state);
  }

  Future<void> logout() async {
    print("logout");
    state = state.copyWith(
      navigatorIndex: 0,
      token: null,
      autoLoginResult: null,
      selectedGame: null,
    );
    _refreshTokenTimer?.cancel();
    _refreshTokenTimer = null;
    ref.read(userProvider.notifier).clearData();
    await _hiveBox!.put("appState", state);
  }

  Future<bool> tryAutoLogin() async {
    if (state.token == null) {
      return false;
    }
    await refreshToken();
    return true;
  }

  void setConnectivity(bool val) {
    state = state.copyWith(isConnectedInternet: val);
  }

  void setAutoLogin(bool val) {
    state = state.copyWith(autoLoginResult: val);
  }

  Future<void> refreshToken() async {
    if (state.token == null) return;
    // await ref.read(natsServiceProvider.notifier).resetConnection();
    // final response =
    //     await ref.read(natsServiceProvider.notifier).makeMicroserviceRequest(
    //           "auth.refreshToken",
    //           jsonEncode({
    //             "accessToken": state.token!.accessToken,
    //             "refreshToken": state.token!.id,
    //           }),
    //           isAuth: true,
    //         );
    // final json = jsonDecode(response) as Map<String, dynamic>;
    // final token = Token.fromJson(json["token"]);
    // final creds = json["creds"];
    // await ref
    //     .read(natsServiceProvider.notifier)
    //     .updateConnection(creds, token.user);

    state = state.copyWith(token: state.token, autoLoginResult: true);
    // _refreshTokenTimer = Timer(
    //   token.accessTokenExpiry.difference(
    //     DateTime.now(),
    //   ),
    //   () {
    //     refreshToken();
    //   },
    // );
    await _hiveBox!.put("appState", state);
  }

  // Future<void> requestChangePassword(String email) async {
  //   await ref.read(natsServiceProvider.notifier).makeMicroserviceRequest(
  //         "auth.requestChangePassword",
  //         jsonEncode({
  //           "email": email,
  //         }),
  //         isAuth: true,
  //       );
  // }
}

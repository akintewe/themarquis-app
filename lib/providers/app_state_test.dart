import 'package:marquis_v2/models/app_state.dart';
import 'package:marquis_v2/providers/app_state.dart';

class AppStateTest extends AppState {
  AppStateTest() : super();

  @override
  AppStateData build() {
    return AppStateData();
  }

  @override
  Future<void> login(String email) async {
    state = state.copyWith(
      accessToken: "testToken",
      refreshToken: "testRefreshToken",
      accessTokenExpiry: DateTime.now().add(
        const Duration(days: 1),
      ),
      refreshTokenExpiry: DateTime.now().add(
        const Duration(days: 1),
      ),
    );
  }

  @override
  void selectGameSessionId(String? game, String? id) {
    state = state.copyWith(selectedGame: game, selectedGameSessionId: id);
  }

  @override
  Future<void> refreshToken([int tries = 1]) async {
    return;
  }

  @override
  Future<bool> tryAutoLogin() async {
    state = state.copyWith(
      autoLoginResult: false,
    );
    return false;
  }

  @override
  Future<void> logout() async {
    state = state.copyWith(accessToken: null, refreshToken: null);
  }
}

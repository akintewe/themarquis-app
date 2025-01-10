import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/games/ludo/models/ludo_session.dart';

class LudoSessionTest extends LudoSession {
  LudoSessionTest() : super();

  @override
  LudoSessionData? build() {
    return null;
  }

  @override
  Future<void> getLudoSession() async {
    return;
  }

  @override
  Future<LudoSessionData?> getLudoSessionFromId(String id) async {
    return null;
  }

  @override
  Future<List<LudoSessionData>> getOpenSessions() async {
    return [];
  }

  @override
  Future<List<Map>> getTransactions(String id) async {
    return [];
  }

  @override
  Future<List<int>> generateMove() async {
    return [];
  }

  @override
  Future<void> playMove(String tokenId) async {
    return;
  }

  @override
  Future<void> clearData({bool refreshUser = false}) async {
    return;
  }

  @override
  void connectWebSocket() {
    return;
  }

  @override
  Future<void> createSession(
    String amount,
    String color,
    String tokenAddress,
  ) async {
    state = LudoSessionData(
      id: "testSessionId",
      status: "status",
      nextPlayer: "nextPlayer",
      nonce: "nonce",
      color: color,
      playAmount: amount,
      playToken: tokenAddress,
      sessionUserStatus: List.generate(4, (index) {
        return LudoSessionUserStatus(
          playerId: index,
          playerTokensPosition: [],
          playerWinningTokens: [false, false, false, false],
          userId: index,
          email: "email",
          role: "role",
          status: "status",
          points: 0,
          playerTokensCircled: [false, false, false, false],
          color: "red",
        );
      }),
      nextPlayerId: 1,
      creator: "creator",
      createdAt: DateTime.now(),
      currentDiceValue: 0,
      playMoveFailed: false,
    );
  }

  @override
  Future<void> joinSession(String sessionId, String color) async {
    return;
  }

  @override
  Future<void> closeSession(String tokenId) async {
    return;
  }

  @override
  Future<void> exitSession() async {
    return;
  }
}

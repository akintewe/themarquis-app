import 'package:marquis_v2/games/checkers/core/models/positions.dart';

enum GameEventType { moved, killed, winner, king, lobbyCreated }

class GameEvent {
  final GameEventType type;
  final BigInt sessionId;
  final String player;
  final int? row;
  final int? col;
  final Position? position;

  const GameEvent({
    required this.type,
    required this.sessionId,
    required this.player,
    this.row,
    this.col,
    this.position,
  });

  factory GameEvent.moved(Map<String, dynamic> data) => GameEvent(
        type: GameEventType.moved,
        sessionId: BigInt.parse(data['session_id']),
        player: data['player'],
        row: data['row'],
        col: data['col'],
      );

  factory GameEvent.killed(Map<String, dynamic> data) => GameEvent(
        type: GameEventType.killed,
        sessionId: BigInt.parse(data['session_id']),
        player: data['player'],
        row: data['row'],
        col: data['col'],
      );

  factory GameEvent.winner(Map<String, dynamic> data) => GameEvent(
        type: GameEventType.winner,
        sessionId: BigInt.parse(data['session_id']),
        player: data['player'],
        position: Position.fromValue(data['position']),
      );

  factory GameEvent.king(Map<String, dynamic> data) => GameEvent(
        type: GameEventType.king,
        sessionId: BigInt.parse(data['session_id']),
        player: data['player'],
        row: data['row'],
        col: data['col'],
      );

  factory GameEvent.lobbyCreated(Map<String, dynamic> data) {
    return GameEvent(
      type: GameEventType.lobbyCreated,
      sessionId: BigInt.parse(data['session_id']),
      player: data['creator'],
    );
  }
}

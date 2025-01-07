import 'package:marquis_v2/games/checkers/core/models/cordinates.dart';
import 'package:marquis_v2/games/checkers/core/models/positions.dart';

class Piece {
  final BigInt sessionId;
  final int row;
  final int col;
  final String player;
  final Position position;
  final bool isKing;
  final bool isAlive;

  const Piece({
    required this.sessionId,
    required this.row,
    required this.col,
    required this.player,
    required this.position,
    required this.isKing,
    required this.isAlive,
  });

  Coordinates get coordinates => Coordinates(row: row, col: col);

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId.toString(),
        'row': row,
        'col': col,
        'player': player,
        'position': position.value,
        'isKing': isKing,
        'isAlive': isAlive,
      };

  factory Piece.fromJson(Map<String, dynamic> json) => Piece(
        sessionId: BigInt.parse(json['sessionId']),
        row: json['row'] as int,
        col: json['col'] as int,
        player: json['player'] as String,
        position: Position.fromValue(json['position'] as int),
        isKing: json['isKing'] as bool,
        isAlive: json['isAlive'] as bool,
      );

  Piece copyWith({
    BigInt? sessionId,
    int? row,
    int? col,
    String? player,
    Position? position,
    bool? isKing,
    bool? isAlive,
  }) =>
      Piece(
        sessionId: sessionId ?? this.sessionId,
        row: row ?? this.row,
        col: col ?? this.col,
        player: player ?? this.player,
        position: position ?? this.position,
        isKing: isKing ?? this.isKing,
        isAlive: isAlive ?? this.isAlive,
      );
}

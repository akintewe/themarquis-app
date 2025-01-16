import 'package:marquis_v2/games/checkers/core/extensions/felt_extensions.dart';
import 'package:starknet/starknet.dart';
import 'package:marquis_v2/games/checkers/core/models/positions.dart';
import 'package:marquis_v2/games/checkers/core/models/pieces.dart';
import 'package:marquis_v2/games/checkers/core/models/cordinates.dart';

class ContractBindings {
  static Future<Piece> decodePiece(List<Felt> response) async {
    return Piece(
      sessionId: response[0].toBigInt(),
      row: response[1].toInt(),
      col: response[2].toInt(),
      player: response[3].toString(),
      position: Position.fromValue(response[4].toInt()),
      isKing: response[5].toBool(),
      isAlive: response[6].toBool(),
    );
  }

  static List<Felt> encodePiece(Piece piece) {
    return [
      Felt(piece.sessionId),
      Felt(piece.row as BigInt),
      Felt(piece.col as BigInt),
      Felt.fromString(piece.player),
      Felt(piece.position.value as BigInt),
      Felt((piece.isKing ? 1 : 0) as BigInt),
      Felt((piece.isAlive ? 1 : 0) as BigInt),
    ];
  }

  static Future<List<Felt>> encodeMove(
    BigInt sessionId,
    Coordinates from,
    Coordinates to,
  ) async {
    return [
      Felt(sessionId),
      Felt(from.row as BigInt),
      Felt(from.col as BigInt),
      Felt(to.row as BigInt),
      Felt(to.col as BigInt),
    ];
  }

  static Future<Map<String, dynamic>> decodeGameEvent(List<Felt> response) async {
    return {
      'session_id': response[0].toBigInt(),
      'player': response[1].toString(),
      'event_type': response[2].toInt(),
      'row': response[3].toInt(),
      'col': response[4].toInt(),
    };
  }

  static Future<Map<String, dynamic>> decodeSession(List<Felt> response) async {
    return {
      'player1': response[0].toString(),
      'player2': response[1].toString(),
      'state': response[2].toInt(),
      'winner': response[3].toString(),
      'turn': response[4].toInt(),
    };
  }
} 
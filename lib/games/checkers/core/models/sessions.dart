import 'package:starknet/starknet.dart';

class Session {
  final BigInt id;
  final String player1;
  final String player2;
  final int state;
  final String winner;
  final int turn;

  const Session({
    required this.id,
    required this.player1,
    required this.player2,
    required this.state,
    required this.winner,
    required this.turn,
  });

  bool get isWaiting => state == 0;
  bool get isPlaying => state == 1;
  bool get isFinished => state == 2;

  factory Session.fromContractResponse(BigInt id, List<Felt> response) =>
      Session(
        id: id,
        player1: response[0].toString(),
        player2: response[1].toString(),
        state: response[2].toInt(),
        winner: response[3].toString(),
        turn: response[4].toInt(),
      );
}

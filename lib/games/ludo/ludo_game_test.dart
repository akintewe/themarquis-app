import 'dart:async';

import 'package:marquis_v2/games/ludo/components/player_pin.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class LudoGameTest extends LudoGame {
  Map<int, int> playerTurns = {0: 0, 1: 0, 2: 0, 3: 0};
  Timer? autoPlayTimer;

  LudoGameTest() : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  Future<void> rollDice() async {
    if (autoPlayTimer == null) {
      startAutoPlay();
    }
  }

  void startRandomPlay() {
    autoPlayTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Roll the dice
      dice.value = 6;

      // Get all movable pins for the current player
      final movablePins = getMovablePins(currentPlayer, dice.value);

      if (movablePins.isNotEmpty) {
        // Randomly select a pin to move
        final randomPin = movablePins[dice.random.nextInt(movablePins.length)];
        randomPin.movePin(null);

        // Check if the game is over
        if (isPlayerFinished(currentPlayer)) {
          timer.cancel();
          print("Player $currentPlayer has won the game!");
          return;
        }
      } else if (dice.value == 6) {
        // Try to move a pin out of the home
        final playerHome = playerHomes[currentPlayer];
        final availableHomePins =
            playerHome.homePins.where((pin) => pin != null).toList();

        if (availableHomePins.isNotEmpty) {
          final randomHomePin =
              availableHomePins[dice.random.nextInt(availableHomePins.length)];
          final homeIndex = playerHome.homePins.indexOf(randomHomePin);
          board.addPin(playerHome.removePin(randomHomePin!, homeIndex)
            ..position += playerHome.position);
        }
      }

      // Move to the next player
      nextPlayer();
    });
  }

  List<PlayerPin> getMovablePins(int playerIndex, int diceValue) {
    List<PlayerPin> movablePins = [];

    // Check pins on the board
    for (var pin in board.children.whereType<PlayerPin>()) {
      if (pin.playerIndex == playerIndex &&
          pin.currentPosIndex + diceValue <= 57) {
        movablePins.add(pin);
      }
    }

    return movablePins;
  }

  bool isPlayerFinished(int playerIndex) {
    return destination.children
            .whereType<PlayerPin>()
            .where((pin) => pin.playerIndex == playerIndex)
            .length ==
        4;
  }

  void startAutoPlay() {
    autoPlayTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (playerTurns[currentPlayer]! >=
          mockPlayerRouteMap[currentPlayer]!.length) {
        timer.cancel();
        print("Auto-play finished for player $currentPlayer");
        return;
      }

      final move =
          mockPlayerRouteMap[currentPlayer]![playerTurns[currentPlayer]!];
      dice.value = move[0];
      final pinToMove = board.getPinWithIndex(currentPlayer, move[1]);

      if (pinToMove != null) {
        pinToMove.movePin(null);
        playerTurns[currentPlayer] = playerTurns[currentPlayer]! + 1;
        nextPlayer();
      } else {
        if (dice.value == 6) {
          final playerHome = playerHomes[currentPlayer];
          board.addPin(
              playerHome.removePin(playerHome.homePins[move[1]]!, move[1])
                ..position += playerHome.position);
          playerTurns[currentPlayer] = playerTurns[currentPlayer]! + 1;
          nextPlayer();
        } else {
          print("Error: Pin not found for move $move player $currentPlayer");
          timer.cancel();
        }
      }
    });
  }

  @override
  void onRemove() {
    autoPlayTimer?.cancel();
    super.onRemove();
  }
}

const mockPlayerRouteMap = {
  0: [
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [5, 0],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [5, 1],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [5, 2],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [5, 3],
  ],
  1: [
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [5, 0],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [5, 1],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [5, 2],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [5, 3],
  ],
  2: [
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [5, 0],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [5, 1],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [5, 2],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [5, 3],
  ],
  3: [
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [6, 0],
    [5, 0],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [6, 1],
    [5, 1],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [6, 2],
    [5, 2],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [6, 3],
    [5, 3],
  ]
};

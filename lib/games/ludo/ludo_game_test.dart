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
      startRandomPlay();
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
          pin.currentPosIndex + diceValue <= 47) {
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
    [6, 0], // Turn 1: Red moves first pin out of base
    [4, 0], // Turn 2: Red moves first pin to position 4
    [6, 1], // Turn 3: Red moves second pin out of base
    [3, 0], // Turn 4: Red moves first pin to position 7
    [5, 1], // Turn 5: Red moves second pin to position 5
    [6, 2], // Turn 6: Red moves third pin out of base
    [
      4,
      0
    ], // Turn 7: Red moves first pin to position 11 (attacks Blue, sending Blue's pin back to base)
    [6, 3], // Turn 8: Red moves fourth pin out of base
    [2, 1], // Turn 9: Red moves second pin to position 7
    [4, 0], // Turn 10: Red moves first pin to position 15
    [5, 1], // Turn 11: Red moves second pin to position 12
    [6, 0], // Turn 12: Red's first pin reaches home (position 18)
    [3, 2], // Turn 13: Red moves third pin to position 5
    [4, 3], // Turn 14: Red moves fourth pin to position 4
    [5, 2], // Turn 15: Red moves third pin to position 10
    [
      6,
      1
    ], // Turn 16: Red moves second pin to position 18 (second pin reaches home)
    [4, 3], // Turn 17: Red moves fourth pin to position 8
    [3, 2], // Turn 18: Red moves third pin to position 13
    [4, 3], // Turn 19: Red moves fourth pin to position 12
    [
      6,
      2
    ], // Turn 20: Red moves third pin to position 18 (third pin reaches home)
    [3, 3], // Turn 21: Red moves fourth pin to position 15
    [6, 3] // Turn 22: Red's fourth pin reaches home (position 18)
  ],
  1: [
    [6, 0], // Turn 1: Blue moves first pin out of base
    [5, 0], // Turn 2: Blue moves first pin to position 5
    [6, 1], // Turn 3: Blue moves second pin out of base
    [4, 0], // Turn 4: Blue moves first pin to position 9
    [6, 2], // Turn 5: Blue moves third pin out of base
    [3, 0], // Turn 6: Blue moves first pin to position 12
    [5, 1], // Turn 7: Blue moves second pin to position 5
    [4, 0], // Turn 8: Blue moves first pin to position 16
    [
      5,
      1
    ], // Turn 9: Blue moves second pin to position 10 (attacked by Red and sent back to base)
    [6, 1], // Turn 10: Blue moves second pin out of base again
    [
      3,
      0
    ], // Turn 11: Blue moves first pin to position 19 (Blue's first pin reaches home)
    [5, 1], // Turn 12: Blue moves second pin to position 8
    [4, 2], // Turn 13: Blue moves third pin to position 8
    [6, 3], // Turn 14: Blue moves fourth pin out of base
    [3, 1], // Turn 15: Blue moves second pin to position 11
    [5, 2], // Turn 16: Blue moves third pin to position 13
    [4, 3], // Turn 17: Blue moves fourth pin to position 4
    [
      3,
      2
    ], // Turn 18: Blue moves third pin to position 16 (third pin reaches home)
    [4, 1], // Turn 19: Blue moves second pin to position 15
    [
      6,
      1
    ], // Turn 20: Blue moves second pin to position 18 (second pin reaches home)
    [3, 3], // Turn 21: Blue moves fourth pin to position 7
    [6, 3] // Turn 22: Blue's fourth pin reaches home
  ],
  2: [
    [6, 0], // Turn 1: Green moves first pin out of base
    [5, 0], // Turn 2: Green moves first pin to position 5
    [6, 1], // Turn 3: Green moves second pin out of base
    [4, 0], // Turn 4: Green moves first pin to position 9
    [6, 2], // Turn 5: Green moves third pin out of base
    [3, 0], // Turn 6: Green moves first pin to position 12
    [5, 1], // Turn 7: Green moves second pin to position 5
    [4, 0], // Turn 8: Green moves first pin to position 16
    [
      5,
      1
    ], // Turn 9: Green moves second pin to position 10 (attacked by Red and sent back to base)
    [6, 1], // Turn 10: Green moves second pin out of base again
    [
      3,
      0
    ], // Turn 11: Green moves first pin to position 19 (Green's first pin reaches home)
    [5, 1], // Turn 12: Green moves second pin to position 8
    [4, 2], // Turn 13: Green moves third pin to position 8
    [6, 3], // Turn 14: Green moves fourth pin out of base
    [3, 1], // Turn 15: Green moves second pin to position 11
    [5, 2], // Turn 16: Green moves third pin to position 13
    [4, 3], // Turn 17: Green moves fourth pin to position 4
    [
      3,
      2
    ], // Turn 18: Green moves third pin to position 16 (third pin reaches home)
    [4, 1], // Turn 19: Green moves second pin to position 15
    [
      6,
      1
    ], // Turn 20: Green moves second pin to position 18 (second pin reaches home)
    [3, 3], // Turn 21: Green moves fourth pin to position 7
    [6, 3] // Turn 22: Green's fourth pin reaches home
  ],
  3: [
    [6, 0], // Turn 1: Yellow moves first pin out of base
    [5, 0], // Turn 2: Yellow moves first pin to position 5
    [6, 1], // Turn 3: Yellow moves second pin out of base
    [4, 0], // Turn 4: Yellow moves first pin to position 9
    [6, 2], // Turn 5: Yellow moves third pin out of base
    [3, 0], // Turn 6: Yellow moves first pin to position 12
    [5, 1], // Turn 7: Yellow moves second pin to position 5
    [4, 0], // Turn 8: Yellow moves first pin to position 16
    [
      5,
      1
    ], // Turn 9: Yellow moves second pin to position 10 (attacked by Red and sent back to base)
    [6, 1], // Turn 10: Yellow moves second pin out of base again
    [
      3,
      0
    ], // Turn 11: Yellow moves first pin to position 19 (Yellow's first pin reaches home)
    [5, 1], // Turn 12: Yellow moves second pin to position 8
    [4, 2], // Turn 13: Yellow moves third pin to position 8
    [6, 3], // Turn 14: Yellow moves fourth pin out of base
    [3, 1], // Turn 15: Yellow moves second pin to position 11
    [5, 2], // Turn 16: Yellow moves third pin to position 13
    [4, 3], // Turn 17: Yellow moves fourth pin to position 4
    [
      3,
      2
    ], // Turn 18: Yellow moves third pin to position 16 (third pin reaches home)
    [4, 1], // Turn 19: Yellow moves second pin to position 15
    [
      6,
      1
    ], // Turn 20: Yellow moves second pin to position 18 (second pin reaches home)
    [3, 3], // Turn 21: Yellow moves fourth pin to position 7
    [6, 3] // Turn 22: Yellow's fourth pin reaches home
  ]
};

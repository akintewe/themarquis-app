import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:marquis_v2/games/ludo/components/player_pin.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/models/ludo_session.dart';
import 'package:flutter/material.dart';

class MockLudoSessionProvider {
  final Random random = Random();

  Future<int> rollDice() async {
    return random.nextInt(6) + 1;
  }

  Future<void> playMove(String pieceIndex) async {
    // Simulate a delay for the move
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class LudoGameTest extends LudoGame {
  late MockLudoSessionProvider mockSessionProvider;

  LudoGameTest() : super();

  @override
  Future<void> onLoad() async {
    mockSessionProvider = MockLudoSessionProvider();
    await super.onLoad();
    // Initialize the game state directly instead of using overlays
    playState = PlayState.playing;
    startAutoPlay();
  }

  @override
  Future<List<int>> generateMove() async {
    int diceValue = await mockSessionProvider.rollDice();
    return [diceValue];
  }

  @override
  Future<void> playMove(int index, {bool isAuto = false}) async {
    await mockSessionProvider.playMove(index.toString());
    await super.playMove(index, isAuto: isAuto);
  }

  // Override overlay methods to prevent errors
  @override
  void showMessage(String message,
      {bool isError = false, int durationSeconds = 3}) {
    print("Message: $message");
  }

  @override
  void showSnackBar(String message) {
    print("SnackBar: $message");
  }

  @override
  void showErrorDialog(String errorMessage) {
    print("Error: $errorMessage");
  }

  void startAutoPlay() {
    Future.delayed(const Duration(seconds: 1), () async {
      while (playState == PlayState.playing) {
        await autoPlayMove();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    });
  }

  Future<void> autoPlayMove() async {
    if (playState != PlayState.playing) return;

    if (!playerCanMove) {
      await rollDice();
    }

    List<PlayerPin> movablePins = getMovablePins();

    if (movablePins.isNotEmpty) {
      PlayerPin pinToMove = movablePins[Random().nextInt(movablePins.length)];
      await playMove(pinToMove.homeIndex);
    } else if (dice.value == 6) {
      List<PlayerPin?> homePins = playerHomes[currentPlayer].homePins;
      List<PlayerPin> availableHomePins =
          homePins.whereType<PlayerPin>().toList();
      if (availableHomePins.isNotEmpty) {
        PlayerPin pinToMove =
            availableHomePins[Random().nextInt(availableHomePins.length)];
        await playMove(pinToMove.homeIndex);
      }
    }

    checkForWinner();
    printGameState();
  }

  List<PlayerPin> getMovablePins() {
    List<PlayerPin> movablePins = [];
    for (var pin in board.children.whereType<PlayerPin>()) {
      if (pin.playerIndex == currentPlayer && pin.canMove) {
        movablePins.add(pin);
      }
    }
    return movablePins;
  }

  void checkForWinner() {
    for (int i = 0; i < 4; i++) {
      if (playerHomes[i].isHomeEmpty && board.getPlayerPinsOnBoard(i).isEmpty) {
        winnerIndex = i;
        playState = PlayState.finished;
        print("Player $i has won the game!");
        break;
      }
    }
  }

  void printGameState() {
    print('Current player: $currentPlayer');
    print('Dice value: ${dice.value}');
    print('Game state: $playState');
    print('Pins on board:');
    for (var pin in board.children.whereType<PlayerPin>()) {
      print(
          'Player ${pin.playerIndex}, Pin ${pin.homeIndex}, Position ${pin.currentPosIndex}');
    }
    print('---');
  }
}

void main() {
  runApp(
    GameWidget(
      game: LudoGameTest(),
    ),
  );
}

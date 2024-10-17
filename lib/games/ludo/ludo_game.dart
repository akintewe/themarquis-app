import 'dart:async' as dart_async;

// ignore_for_file: unused_field

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:marquis_v2/games/ludo/components/board.dart';
import 'package:marquis_v2/games/ludo/components/destination.dart';
import 'package:marquis_v2/games/ludo/components/dice.dart';
import 'package:marquis_v2/games/ludo/components/player_home.dart';
import 'package:marquis_v2/games/ludo/components/player_pin.dart';
import 'package:marquis_v2/games/ludo/config.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/models/ludo_session.dart';
import 'package:marquis_v2/providers/user.dart';

enum PlayState { welcome, waiting, playing, finished }

class LudoGame extends FlameGame with TapCallbacks, RiverpodGameMixin {
  bool isInit = false;
  late Dice dice;
  late Board board;
  late TextComponent turnText;
  late Destination destination;
  final List<PlayerHome> playerHomes = [];
  final List<List<int>> playerPinLocations = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];
  int _currentPlayer = 0;
  int _userIndex = -1;
  bool playerCanMove = false;
  final int totalPlayers = 4;
  int? winnerIndex;
  LudoSessionData? _sessionData;
  int pendingMoves = 0;
  String? currentMessage;
  bool isErrorMessage = false;
  dart_async.Timer? _messageTimer;

  LudoGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;
  double get unitSize => size.x / 17;
  Vector2 get center => size / 2;

  int get currentPlayer => _currentPlayer;
  List<Color> get listOfColors =>
      _sessionData?.getListOfColors ??
      const [
        Color(0xffd04c2f),
        Color(0xff2fa9d0),
        Color(0xff2fd06f),
        Color(0xffb0d02f),
      ];
  int get userIndex => _userIndex;
  List<String> get playerNames => _sessionData!.sessionUserStatus
      .map((user) => user.email.split('@')[0])
      .toList();

  Future<List<int>> generateMove() async {
    try {
      final res = await ref.read(ludoSessionProvider.notifier).generateMove();
      return res;
    } catch (e) {
      showErrorDialog(e.toString());
      return [];
    }
  }

  Future<void> playMove(int index) async {
    try {
      dice.state = DiceState.playingMove;
      await ref.read(ludoSessionProvider.notifier).playMove(index.toString());
    } catch (e) {
      dice.state = DiceState.rolledDice;
      showErrorDialog(e.toString());
    }
  }

  late PlayState _playState;
  PlayState get playState => _playState;
  set playState(PlayState playState) {
    _playState = playState;
    switch (playState) {
      case PlayState.welcome:
      case PlayState.waiting:
      case PlayState.finished:
        overlays.add(playState.name);
      case PlayState.playing:
        overlays.remove(PlayState.welcome.name);
        overlays.remove(PlayState.waiting.name);
        overlays.remove(PlayState.finished.name);
        if (_sessionData != null) {
          initGame();
        }
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    playState = PlayState.welcome;
    _sessionData = ref.read(ludoSessionProvider);
    addToGameWidgetBuild(() {
      ref.listen(ludoSessionProvider, (prev, next) async {
        _sessionData = next;
        if (_sessionData != null) {
          if (_playState == PlayState.welcome) {
            playState = PlayState.waiting;
          }
          // Update pin locations
          if (_playState == PlayState.playing && isInit) {
            try {
              _currentPlayer = _sessionData!.nextPlayerIndex;
              playerCanMove = false;
              updateTurnText();

              if (_sessionData!.currentDiceValue != null) {
                int diceValue = _sessionData!.currentDiceValue!;
                dice.values = [
                  ...List.filled(diceValue ~/ 6, 6),
                  if (diceValue % 6 != 0) diceValue % 6
                ];
                dice.update(0);
              }
              if (_currentPlayer == _userIndex) {
                if (_sessionData!.playMoveFailed ?? false) {
                  dice.state = DiceState.active;
                } else {
                  dice.state = DiceState.preparing;
                }
              } else {
                dice.state = DiceState.inactive;
              }
              for (final player in _sessionData!.sessionUserStatus) {
                final pinLocations = player.playerTokensPosition;
                final currentPinLocations = playerPinLocations[player.playerId];
                final playerHome = playerHomes[player.playerId];

                for (int i = 0; i < pinLocations.length; i++) {
                  final pinLocation = int.parse(pinLocations[i]) +
                      (player.playerTokensCircled?[i] ?? false ? 52 : 0);
                  if (player.playerWinningTokens[i] == true &&
                      currentPinLocations[i] != -1) {
                    playerPinLocations[player.playerId][i] = -1;
                    final pin = board.getPinWithIndex(player.playerId, i);
                    board.remove(pin!);
                    await pin.removed;
                    destination.addPin(pin);
                  } else if (player.playerWinningTokens[i] != true &&
                      currentPinLocations[i] != pinLocation) {
                    if (currentPinLocations[i] == 0 && pinLocation != 0) {
                      print('Removing pin');
                      final pin = playerHome.removePin(i);
                      await pin.removed;
                      print('Adding pin');
                      await board.addPin(pin,
                          location: pinLocation - player.playerId * 13 - 1);
                      print('Pin added');
                    } else if (currentPinLocations[i] != 0 &&
                        pinLocation == 0) {
                      final pin = board.getPinWithIndex(player.playerId, i);
                      await board.attackPin(pin!);
                    } else {
                      final pin = board.getPinWithIndex(player.playerId, i);
                      await pin
                          ?.movePin(pinLocation - player.playerId * 13 - 1);
                    }

                    playerPinLocations[player.playerId][i] = pinLocation;
                  }
                }
              }
              if (_currentPlayer == _userIndex &&
                  dice.state == DiceState.preparing) {
                Future.delayed(const Duration(seconds: 8), () {
                  dice.state = DiceState.active;
                });
              }
            } catch (e) {
              showErrorDialog(e.toString());
            }
          }
        }
      });
    });
  }

  Future<void> initGame() async {
    await Flame.images.load('spritesheet.png');
    await Flame.images.load('avatar_spritesheet.png');
    await Flame.images.load('dice_interface.png');

    camera.viewfinder.anchor = Anchor.topLeft;
    _userIndex = _sessionData!.sessionUserStatus.indexWhere(
        (user) => user.userId.toString() == ref.read(userProvider)?.id);
    _currentPlayer = _sessionData!.nextPlayerIndex;
    board = Board();
    await add(board);
    final positions = [
      Vector2(center.x - unitSize * 6.25,
          center.y - unitSize * 6.25), // Top-left corner (Player 1)
      Vector2(center.x + unitSize * 2.25,
          center.y - unitSize * 6.25), // Top-right corner (Player 2)
      Vector2(center.x + unitSize * 2.25,
          center.y + unitSize * 2.25), // Bottom-right corner (Player 3)
      Vector2(center.x - unitSize * 6.25,
          center.y + unitSize * 2.25), // Bottom-left corner (Player 4)
    ];
    for (int i = 0; i < positions.length; i++) {
      playerHomes
          .add(PlayerHome(i, _sessionData!.sessionUserStatus[i], positions[i]));
      await add(playerHomes.last);
    }

    destination = Destination();
    await add(destination);

    dice = Dice(
        size: Vector2(100, 100), position: Vector2(size.x / 2, size.y - 200));
    await add(dice);

    if (_currentPlayer == _userIndex) {
      dice.state = DiceState.active;
    } else {
      dice.state = DiceState.inactive;
    }

    turnText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, 50),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w600,
          color: _sessionData!.getListOfColors[_currentPlayer],
        ),
      ),
    );
    await add(turnText);

    await mounted;

    for (var player in _sessionData!.sessionUserStatus) {
      final pinLocations = player.playerTokensPosition;
      final playerHome = playerHomes[player.playerId];
      for (int i = 0; i < pinLocations.length; i++) {
        var pinLocation = int.parse(pinLocations[i]) +
            (player.playerTokensCircled?[i] ?? false ? 52 : 0);

        if (player.playerWinningTokens[i] == true) {
          playerPinLocations[player.playerId][i] = -1;
          // playerHome.removePin(i);
          final pin = playerHome.removePin(i);
          // await pin.removed;
          destination.addPin(pin);
        } else if (pinLocation != 0 || player.playerTokensCircled?[i] == true) {
          final pin = playerHome.removePin(i);
          //  pin.removed;
          board.addPin(pin,
              location: pinLocation - player.playerId * 13 - 1, isInit: true);
          playerPinLocations[player.playerId][i] = pinLocation;
        }
      }
    }
    updateTurnText();
    isInit = true;
  }

  void updateTurnText() {
    turnText.text =
        '${_currentPlayer == _userIndex ? 'You' : 'Player ${playerNames[_currentPlayer]}'} ${playerCanMove ? 'move turn' : 'roll dice!!'}';
    turnText.textRenderer = TextPaint(
        style: TextStyle(
            fontSize: unitSize * 0.8,
            color: _sessionData!.getListOfColors[_currentPlayer]));
  }

  Future<void> rollDice() async {
    if (playerCanMove) return;
    await dice.roll();

    List<PlayerPin> listOfPlayerPin = board.getPlayerPinsOnBoard(_userIndex);
    List<PlayerPin> movablePins = [];

    for (PlayerPin pin in listOfPlayerPin) {
      if (pin.canMove) {
        movablePins.add(pin);
      }
    }

    if (movablePins.isEmpty && dice.value < 6) {
      showSnackBar("Can not move from Basement, try to get a 6!!");
      final pinsAtHome = playerHomes[_userIndex].pinsAtHome;
      if (pinsAtHome.isNotEmpty) {
        await playMove(pinsAtHome[0]!.homeIndex);
      } else {
        final pins = board.getPlayerPinsOnBoard(_userIndex);
        await playMove(pins[0].homeIndex);
      }
      return;
    }

    if (movablePins.length == 1 && dice.value < 6) {
      // Automatically play move on the only movable pin
      await playMove(movablePins[0].homeIndex);
      return;
    }

    playerCanMove = true;

    // playerCanMove = !movablePins.isEmpty ||
    //     (dice.value >= 6 && !playerHomes[_currentPlayer].isHomeEmpty);

    // if (!playerCanMove) {
    //   final pinsAtHome = playerHomes[_userIndex].pinsAtHome;
    //   if (pinsAtHome.isNotEmpty) {
    //     await playMove(pinsAtHome[0]!.homeIndex);
    //   } else {
    //     final pins = board.getPlayerPinsOnBoard(_userIndex);
    //     await playMove(pins[0].homeIndex);
    //   }
    // }
  }

  void showMessage(String message,
      {bool isError = false, int durationSeconds = 3}) {
    currentMessage = message;
    isErrorMessage = isError;

    // Cancel any existing timer
    _messageTimer?.cancel();

    if (!overlays.isActive('message')) {
      overlays.add('message');
    } else {
      overlays.remove('message');
      overlays.add('message');
    }

    // Set a timer to remove the message after the specified duration
    _messageTimer = dart_async.Timer(Duration(seconds: durationSeconds), () {
      overlays.remove('message');
    });
  }

  void showSnackBar(String message) {
    showMessage(message, durationSeconds: 5);
  }

  void showErrorDialog(String errorMessage) {
    showMessage(errorMessage, isError: true, durationSeconds: 5);
  }

  @override
  Color backgroundColor() => const Color(0xff0f1118);

  @override
  void onRemove() {
    _messageTimer?.cancel();
    super.onRemove();
  }
}

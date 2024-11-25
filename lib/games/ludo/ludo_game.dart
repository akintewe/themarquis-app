import 'dart:async' as dart_async;
import 'dart:async';

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
import 'package:marquis_v2/games/ludo/models/ludo_session.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:marquis_v2/games/ludo/components/dice_container.dart';
import 'package:marquis_v2/games/ludo/components/game_top_bar.dart';

enum PlayState { welcome, waiting, playing, finished }

class LudoGame extends FlameGame with TapCallbacks, RiverpodGameMixin {
  bool isInit = false;
  late DiceContainer diceContainer;
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
  Completer<void>? ludoSessionLoadingCompleter;

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

  Dice get currentDice => diceContainer.currentDice;
  Dice? getPlayerDice(int playerIndex) => playerHomes[playerIndex].playerDice;

  Future<List<int>> generateMove() async {
    try {
      final res = await ref.read(ludoSessionProvider.notifier).generateMove();
      return res;
    } catch (e) {
      showErrorDialog(e.toString());
      return [];
    }
  }

  Future<void> playMove(int index, {bool isAuto = false}) async {
    try {
      if (!isAuto) {
        diceContainer.currentDice.state = DiceState.preparing;
        await Future.delayed(const Duration(seconds: 8), () async {
          diceContainer.currentDice.state = DiceState.playingMove;
          await ref
              .read(ludoSessionProvider.notifier)
              .playMove(index.toString());
        });
      } else {
        diceContainer.currentDice.state = DiceState.playingMove;
        await ref.read(ludoSessionProvider.notifier).playMove(index.toString());
      }
    } catch (e) {
      diceContainer.currentDice.state = DiceState.rolledDice;
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
        if (ludoSessionLoadingCompleter != null) {
          await ludoSessionLoadingCompleter!.future;
        }
        _handleLudoSessionUpdate(next);
      });
    });
  }

  Future<void> _handleLudoSessionUpdate(LudoSessionData? next) async {
    ludoSessionLoadingCompleter = Completer<void>();
    _sessionData = next;
    if (_sessionData != null) {
      if (_sessionData!.message != null) {
        showErrorDialog(_sessionData!.message!);
        if (_sessionData!.message!.startsWith("EXITED")) {
          await ref
              .read(ludoSessionProvider.notifier)
              .clearData(refreshUser: true);
          overlays.remove(PlayState.waiting.name);
          overlays.remove(PlayState.finished.name);
          playState = PlayState.welcome;
          return;
        }
      }
      if (_playState == PlayState.welcome) {
        playState = PlayState.waiting;
      }
      // Update pin locations
      if (_playState == PlayState.playing && isInit) {
        try {
          final prevPlayer = _currentPlayer;
          _currentPlayer = _sessionData!.nextPlayerIndex;
          playerCanMove = false;
          updateTurnText();

          if (_sessionData!.currentDiceValue != null) {
            int diceValue = _sessionData!.currentDiceValue!;
            await prepareNextPlayerDice(prevPlayer, diceValue);
          }
          if (_currentPlayer == _userIndex) {
            if (_sessionData!.playMoveFailed ?? false) {
              diceContainer.currentDice.state = DiceState.active;
            } else {
              diceContainer.currentDice.state = DiceState.preparing;
            }
          } else {
            diceContainer.currentDice.state = DiceState.inactive;
          }
          final movePinsCompleter = Completer<void>();
          for (final player in _sessionData!.sessionUserStatus) {
            final pinLocations = player.playerTokensPosition;
            final currentPinLocations = playerPinLocations[player.playerId];
            final playerHome = playerHomes[player.playerId];
            for (int i = 0; i < pinLocations.length; i++) {
              final pinLocation = int.parse(pinLocations[i]) +
                  (player.playerTokensCircled?[i] ?? false ? 52 : 0);
              if (player.playerWinningTokens[i] == true &&
                  currentPinLocations[i] != -1) {
                // Remove from board and add to destination
                playerPinLocations[player.playerId][i] = -1;
                final pin = board.getPinWithIndex(player.playerId, i);
                await pin?.movePin(56);
                // board.remove(pin!);
                // await pin.removed;
                // destination.addPin(pin);
              } else if (player.playerWinningTokens[i] != true &&
                  currentPinLocations[i] != pinLocation) {
                if (currentPinLocations[i] == 0 && pinLocation != 0) {
                  // Remove from home and add to board
                  final pin = playerHome.removePin(i);
                  if (!pin.isRemoved) {
                    await pin.removed;
                  }

                  await board.addPin(pin,
                      location: pinLocation - player.playerId * 13 - 1);
                } else if (currentPinLocations[i] != 0 && pinLocation == 0) {
                  // Pin attacked
                  final pin = board.getPinWithIndex(player.playerId, i);
                  movePinsCompleter.future.then((_) async {
                    await board.attackPin(pin!);
                  });
                } else {
                  // Move pin
                  final pin = board.getPinWithIndex(player.playerId, i);
                  await pin?.movePin(pinLocation - player.playerId * 13 - 1);
                }
                playerPinLocations[player.playerId][i] = pinLocation;
              }
            }
          }
          movePinsCompleter.complete();
          if (_currentPlayer == _userIndex &&
              diceContainer.currentDice.state == DiceState.preparing) {
            Future.delayed(const Duration(seconds: 8), () {
              diceContainer.currentDice.state = DiceState.active;
            });
          }
        } catch (e) {
          showErrorDialog(e.toString());
        }
      }
    }
    ludoSessionLoadingCompleter?.complete();
    ludoSessionLoadingCompleter = null;
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

    await createAndSetCurrentPlayerDice();

    turnText = TextComponent(
      text: '',
      position: Vector2(size.x / 2, size.y * 0.15),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: unitSize * 1.2,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          shadows: [
            Shadow(
              color: _sessionData!.getListOfColors[_currentPlayer].withOpacity(0.8),
              offset: const Offset(0, 0),
              blurRadius: 20,
            ),
            Shadow(
              color: _sessionData!.getListOfColors[_currentPlayer].withOpacity(0.8),
              offset: const Offset(0, 0),
              blurRadius: 10,
            ),
          ],
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
    final playerName = playerNames[_currentPlayer];
    turnText.text = _currentPlayer == _userIndex 
        ? 'Your Turn'
        : "$playerName's Turn";
    turnText.textRenderer = TextPaint(
      style: TextStyle(
        fontSize: unitSize * 1.2,
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontFamily: 'Orbitron',
        shadows: [
          Shadow(
            color: Color.fromRGBO(9, 138, 238, 1),
            offset: const Offset(0, 0),
            blurRadius: 10,
          ),
          Shadow(
            color: _sessionData!.getListOfColors[_currentPlayer].withOpacity(0.8),
            offset: const Offset(0, 0),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }

  Future<void> rollDice() async {
    print("rollDice called, playerCanMove: $playerCanMove"); // Debug print
    if (playerCanMove) return;
    
    print("Rolling dice..."); // Debug print
    await diceContainer.currentDice.roll();
    print("Dice rolled, value: ${diceContainer.currentDice.value}"); // Debug print

    List<PlayerPin> listOfPlayerPin = board.getPlayerPinsOnBoard(_userIndex);
    List<PlayerPin> movablePins = [];

    for (PlayerPin pin in listOfPlayerPin) {
      if (pin.canMove) {
        movablePins.add(pin);
      }
    }

    // If there are no movable pins and the dice value is less than 6, show a snackbar
    if (movablePins.isEmpty) {
      final pinsAtHome = playerHomes[_userIndex].pinsAtHome;
      if (diceContainer.currentDice.value < 6) {
        if (pinsAtHome.isNotEmpty) {
          showSnackBar("Can not move from Basement, try to get a 6!!");
          // If there are pins at home, play the first one (dummy move)
          await playMove(pinsAtHome[0]!.homeIndex, isAuto: true);
          return;
        } else {
          showSnackBar("No pins to move!!");
          // If there are no pins at home, play the first pin on the board (dummy move)
          final pins = board.getPlayerPinsOnBoard(_userIndex);
          await playMove(pins[0].homeIndex, isAuto: true);
          return;
        }
      } else {
        // If the dice value is greater or equal to 6, play the first pin on the board or the only pin at home
        if (pinsAtHome.isEmpty) {
          showSnackBar("No pins to move!!");
          // If there are no pins at home, play the first pin on the board (dummy move)
          final pins = board.getPlayerPinsOnBoard(_userIndex);
          await playMove(pins[0].homeIndex, isAuto: true);
          return;
        } else if (pinsAtHome.length == 1) {
          // If there is only one pin at home, play it
          await playMove(pinsAtHome[0]!.homeIndex);
          return;
        }
      }
    }

    if ((movablePins.length == 1 && diceContainer.currentDice.value < 6) ||
        (movablePins.length == 1 &&
            diceContainer.currentDice.value > 6 &&
            playerHomes[_userIndex].pinsAtHome.isEmpty)) {
      // Automatically play move on the only movable pin
      await playMove(movablePins[0].homeIndex);
      return;
    }

    playerCanMove = true;

    // Commented out code should also be updated if uncommented in the future
    // playerCanMove = !movablePins.isEmpty ||
    //     (diceContainer.currentDice!.value >= 6 && !playerHomes[_currentPlayer].isHomeEmpty);
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

  Future<void> createAndSetCurrentPlayerDice() async {
    final newDice = Dice(
      size: Vector2(100, 100),
      position: Vector2(size.x / 2, size.y - 200),
      playerIndex: _currentPlayer,
    );
    if (_currentPlayer == _userIndex) {
      newDice.state = DiceState.active;
    } else {
      newDice.state = DiceState.inactive;
    }
    diceContainer = DiceContainer(
      position: Vector2(size.x / 2, size.y - 150),
      size: Vector2(100, 100),
      dice: newDice,
    );
    await add(diceContainer);
  }

  Future<void> prepareNextPlayerDice(int playerIndex, int diceValue) async {
    final playerHome = playerHomes[playerIndex];
    await playerHome.setDiceValue(diceValue);
  }

  Future<void> showDiceDialog() async {
    if (!buildContext!.mounted) return;

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: 120,
            height: 120,
            child: GameWidget(
              game: this,
            ),
          ),
        );
      },
    );

    // Roll the dice
    await rollDice();

    // Close dialog after roll animation
    if (buildContext!.mounted) {
      Navigator.of(buildContext!).pop();
    }
  }
}

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
  List<String> get playerNames =>
      _sessionData!.sessionUserStatus.map((user) => user.email).toList();

  Future<List<int>> generateMove() async {
    return ref.read(ludoSessionProvider.notifier).generateMove();
  }

  Future<void> playMove(int index) async {
    return ref.read(ludoSessionProvider.notifier).playMove(index.toString());
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
            for (final player in _sessionData!.sessionUserStatus) {
              final pinLocations = player.playerTokensPosition;
              final currentPinLocations = playerPinLocations[player.playerId];
              final playerHome = playerHomes[player.playerId];

              for (int i = 0; i < pinLocations.length; i++) {
                final pinLocation = int.parse(pinLocations[i]);

                if (currentPinLocations[i] != pinLocation) {
                  if (currentPinLocations[i] == 0 && pinLocation != 0) {
                    await board.addPin(playerHome.removePin(i),
                        location:
                            (pinLocation - player.playerId * 13 - 1) % 52);
                  } else if (currentPinLocations[i] != 0 && pinLocation == 0) {
                    final pin = board.getPinWithIndex(player.playerId, i);
                    board.attackPin(pin!);
                  } else {
                    final pin = board.getPinWithIndex(player.playerId, i);
                    pin!.movePin((pinLocation - player.playerId * 13 - 1) % 52);
                  }

                  playerPinLocations[player.playerId][i] = pinLocation;
                }
              }
            }
            _currentPlayer = _sessionData!.nextPlayerIndex;
            updateTurnText();
            // TODO: update dice state
            // TODO: update destination state
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
    add(board);
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
      add(playerHomes.last);
    }

    destination = Destination();
    add(destination);

    dice = Dice(
        size: Vector2(100, 100), position: Vector2(size.x / 2, size.y - 200));
    add(dice);

    turnText = TextComponent(
      text: 'Player 1\'s turn',
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
    add(turnText);

    await mounted;

    for (var player in _sessionData!.sessionUserStatus) {
      final pinLocations = player.playerTokensPosition;
      playerPinLocations[player.playerId] =
          pinLocations.map((e) => int.parse(e)).toList();
      final playerHome = playerHomes[player.playerId];
      for (int i = 0; i < pinLocations.length; i++) {
        var pinLocation = pinLocations[i];
        if (pinLocation != '0') {
          board.addPin(playerHome.removePin(i),
              location:
                  (int.parse(pinLocation) - player.playerId * 13 - 1) % 52);
        }
      }
    }
    updateTurnText();
    isInit = true;
  }

  void updateTurnText() {
    turnText.text =
        '${_currentPlayer == _userIndex ? 'Your' : 'Player ${playerNames[_currentPlayer]}'} ${playerCanMove ? 'move turn' : 'roll dice'}';
    turnText.textRenderer = TextPaint(
        style: TextStyle(
            fontSize: unitSize * 0.8,
            color: _sessionData!.getListOfColors[_currentPlayer]));
  }

  Future<void> rollDice() async {
    if (playerCanMove) return;
    await dice.roll();

    playerCanMove = !playerHomes[_currentPlayer].isHomeFull || dice.value == 6;
    if (!playerCanMove) {
      await ref.read(ludoSessionProvider.notifier).playMove("0");
      nextPlayer();
    }
  }

  void nextPlayer() {
    _currentPlayer = (_currentPlayer + 1) % totalPlayers;
  }

  @override
  Color backgroundColor() => const Color(0xff0f1118);
}

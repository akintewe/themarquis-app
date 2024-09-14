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

enum PlayState { welcome, waiting, playing, finished }

class LudoGame extends FlameGame with TapCallbacks, RiverpodGameMixin {
  late Dice dice;
  late Board board;
  late TextComponent turnText;
  late Destination destination;
  final List<PlayerHome> playerHomes = [];
  int _currentPlayer = 0;
  bool playerCanMove = false;
  final int totalPlayers = 4;
  LudoSessionData? _sessionData;

  LudoGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;
  double get unitSize => size.x / 15;
  Vector2 get center => size / 2;

  int get currentPlayer => _currentPlayer;

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
    }
  }

  @override
  void onMount() {
    _sessionData = ref.read(ludoSessionProvider);
    addToGameWidgetBuild(() {
      ref.listen(ludoSessionProvider, (prev, next) {
        _sessionData = next;
        if (_sessionData != null && _playState == PlayState.welcome) {
          playState = PlayState.waiting;
        }
      });
    });
    super.onMount();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    playState = PlayState.playing;

    await Flame.images.load('spritesheet.png');
    await Flame.images.load('avatar_spritesheet.png');

    camera.viewfinder.anchor = Anchor.topLeft;

    board = Board();
    add(board);
    final positions = [
      Vector2(center.x - unitSize * 6.25,
          center.y - unitSize * 6.25), // Top-left corner
      Vector2(center.x + unitSize * 2.25,
          center.y - unitSize * 6.25), // Top-right corner
      Vector2(center.x - unitSize * 6.25,
          center.y + unitSize * 2.25), // Bottom-left corner
      Vector2(center.x + unitSize * 2.25,
          center.y + unitSize * 2.25), // Bottom-right corner
    ];
    for (int i = 0; i < positions.length; i++) {
      playerHomes.add(PlayerHome(i, positions[i]));
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
          color: playerColors[_currentPlayer],
        ),
      ),
    );
    add(turnText);
  }

  Future<void> rollDice() async {
    if (playerCanMove) return;
    dice.roll();
    dice.animate();

    await Future.delayed(const Duration(milliseconds: 500));
    playerCanMove = !playerHomes[_currentPlayer].isHomeFull || dice.value == 6;
    if (!playerCanMove) {
      nextPlayer();
    }
  }

  void nextPlayer() {
    _currentPlayer = (_currentPlayer + 1) % totalPlayers;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    turnText.text =
        'Player ${_currentPlayer + 1}\'s ${playerCanMove ? 'move turn' : 'roll dice'}';
    turnText.textRenderer = TextPaint(
        style: TextStyle(
            fontSize: unitSize * 0.8, color: playerColors[_currentPlayer]));
  }

  @override
  Color backgroundColor() => const Color(0xff0f1118);
}

const mockPlayerRouteMap = {
  0: [
    [6, 0], // Turn 1: Move first token out of base
    [6, 1], // Turn 2: Move second token out of base
    [4, 0], // Turn 3: Move first token forward
    [5, 1], // Turn 4: Move second token forward
    [6, 2], // Turn 5: Move third token out of base
    [3, 0], // Turn 6: Move first token forward
    [6, 3], // Turn 7: Move fourth token out of base
    [1, 2], // Turn 8: Move third token forward
    [2, 1], // Turn 9: Move second token forward
    [4, 0], // Turn 10: Move first token forward (attack Blue at position 10)
    [5, 1], // Turn 11: Move second token forward
    [6, 0], // Turn 12: Move first token forward
    [3, 1], // Turn 13: Move second token forward
    [4, 0], // Turn 14: Move first token forward
    [6, 1], // Turn 15: Move second token forward (attack Green at position 20)
    [5, 2], // Turn 16: Move third token forward
    [4, 0], // Turn 17: Move first token forward
    [6, 0], // Turn 18: First token reaches home
    [2, 2], // Turn 19: Move third token forward
    [3, 3], // Turn 20: Move fourth token forward
    [5, 2], // Turn 21: Move third token forward
    [6, 1], // Turn 22: Move second token forward
    [4, 3], // Turn 23: Move fourth token forward
    [3, 1], // Turn 24: Second token reaches home
    [5, 2], // Turn 25: Move third token forward
    [6, 3], // Turn 26: Move fourth token forward (third token reaches home)
    [4, 3], // Turn 27: Move fourth token forward
    [3, 3] // Turn 28: Fourth token reaches home -> Red wins!
  ],
  1: [
    [6, 0], // Turn 1: Move first token out of base
    [3, 0], // Turn 2: Move first token forward
    [6, 1], // Turn 3: Move second token out of base
    [5, 0], // Turn 4: Move first token forward
    [1, 1], // Turn 5: Move second token forward
    [6, 2], // Turn 6: Move third token out of base
    [2, 0], // Turn 7: Move first token forward
    [6, 3], // Turn 8: Move fourth token out of base
    [
      4,
      0
    ], // Turn 9: Move first token forward (attacked by Red at position 10, sent back to base)
    [5, 1], // Turn 10: Move second token forward
    [3, 2], // Turn 11: Move third token forward
    [6, 1], // Turn 12: Move second token forward
    [4, 1], // Turn 13: Move second token forward
    [6, 2], // Turn 14: Move third token forward
    [3, 0], // Turn 15: Move first token forward again
    [5, 2], // Turn 16: Move third token forward
    [2, 1], // Turn 17: Move second token forward
    [6, 0], // Turn 18: Move first token forward
    [3, 2], // Turn 19: Move third token forward
  ],
  2: [
    [6, 0], // Turn 1: Move first token out of base
    [3, 0], // Turn 2: Move first token forward
    [6, 1], // Turn 3: Move second token out of base
    [5, 0], // Turn 4: Move first token forward
    [4, 0], // Turn 5: Move first token forward
    [6, 2], // Turn 6: Move third token out of base
    [3, 0], // Turn 7: Move first token forward
    [5, 1], // Turn 8: Move second token forward
    [2, 0], // Turn 9: Move first token forward
    [
      4,
      1
    ], // Turn 10: Move second token forward (attacked by Red at position 20, sent back to base)
    [5, 2], // Turn 11: Move third token forward
    [6, 3], // Turn 12: Move fourth token out of base
    [2, 0], // Turn 13: Move first token forward
    [4, 2], // Turn 14: Move third token forward
    [6, 1], // Turn 15: Move second token forward again
    [3, 0], // Turn 16: Move first token forward
    [5, 2], // Turn 17: Move third token forward
    [6, 1], // Turn 18: Move second token forward
  ],
  3: [
    [6, 0], // Turn 1: Move first token out of base
    [5, 0], // Turn 2: Move first token forward
    [3, 0], // Turn 3: Move first token forward
    [2, 0], // Turn 4: Move first token forward
    [6, 1], // Turn 5: Move second token out of base
    [5, 0], // Turn 6: Move first token forward
    [4, 1], // Turn 7: Move second token forward
    [6, 1], // Turn 8: Move second token forward
    [2, 0], // Turn 9: Move first token forward
    [5, 1], // Turn 10: Move second token forward
    [3, 0], // Turn 11: Move first token forward
    [6, 1], // Turn 12: Move second token forward
    [5, 1], // Turn 13: Move second token forward
    [3, 0], // Turn 14: Move first token forward
    [6, 1], // Turn 15: Move second token forward
    [5, 1], // Turn 16: Move second token forward
    [3, 0], // Turn 17: Move first token forward
  ]
};

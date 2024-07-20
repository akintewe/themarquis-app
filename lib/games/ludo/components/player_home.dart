import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:marquis_v2/games/ludo/components/player_avatar.dart';
import 'package:marquis_v2/games/ludo/components/player_pin.dart';
import 'package:marquis_v2/games/ludo/config.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class PlayerHome extends PositionComponent with HasGameReference<LudoGame> {
  final int playerIndex;
  late TextComponent playerName;
  late List<PlayerPin?> _homePins;
  late List<Vector2> _homePinLocations;
  late List<Vector2> _avatarPositions;

  bool get isHomeFull =>
      _homePins[0] != null &&
      _homePins[1] != null &&
      _homePins[2] != null &&
      _homePins[3] != null;

  PlayerHome(this.playerIndex, Vector2 position) : super(position: position);
  List<String> playerNames = [
    "Carlos",
    "Mohdi",
    "Yixuan",
    "Jupeng",
  ];
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.unitSize * 2.5, game.unitSize * 2.5);

    _homePinLocations = [
      Vector2(game.unitSize * 1, game.unitSize * 1),
      Vector2(game.unitSize * 2.5, game.unitSize * 1),
      Vector2(game.unitSize * 1, game.unitSize * 2.2),
      Vector2(game.unitSize * 2.5, game.unitSize * 2.2),
    ];
    _homePins = [
      PlayerPin(
        Vector2(game.unitSize * 1, game.unitSize * 1),
        playerIndex,
        (event, pin) {
          if (game.dice.value == 6) {
            game.board.addPin(removePin(pin, 0));
            game.playerCanMove = false;
          }
        },
      ),
      PlayerPin(
        Vector2(game.unitSize * 2.5, game.unitSize * 1),
        playerIndex,
        (event, pin) {
          if (game.dice.value == 6) {
            game.board.addPin(removePin(pin, 1));
            game.playerCanMove = false;
          }
        },
      ),
      PlayerPin(
        Vector2(game.unitSize * 1, game.unitSize * 2.2),
        playerIndex,
        (event, pin) {
          if (game.dice.value == 6) {
            game.board.addPin(removePin(pin, 2));
            game.playerCanMove = false;
          }
        },
      ),
      PlayerPin(
        Vector2(game.unitSize * 2.5, game.unitSize * 2.2),
        playerIndex,
        (event, pin) {
          if (game.dice.value == 6) {
            game.board.addPin(removePin(pin, 3));
            game.playerCanMove = false;
          }
        },
      ),
    ];

    for (var pin in _homePins) {
      add(pin!);
    }

    _avatarPositions = [
      Vector2(0, game.unitSize * -4.5), //top left
      Vector2(game.unitSize * 1.25, game.unitSize * -4.5), //top right
      Vector2(0, game.unitSize * 5), //bottom left
      Vector2(game.unitSize * 1.25, game.unitSize * 5), //bottom right
    ];

    //player name
    playerName = TextComponent(
      text: playerNames[playerIndex],
      position: (playerIndex == 0 || playerIndex == 1)
          ? (playerIndex % 2 == 0)
              ? Vector2(size.x / 2, size.y / -2)
              : Vector2(size.x / 0.95, size.y / -2)
          : (playerIndex % 2 == 0)
              ? Vector2(size.x / 2, size.y / 0.295) //btm left
              : Vector2(size.x / 0.95, size.y / 0.295), //btm right
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
    add(playerName);

    add(PlayerAvatar(_avatarPositions[playerIndex], playerIndex));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //player home
    final rrect = RRect.fromLTRBR(0, 0, game.unitSize * 4, game.unitSize * 4,
        const Radius.circular(16.0));
    final paint = Paint()
      ..color = playerColors[playerIndex]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      rrect,
      paint,
    );
    canvas.drawRRect(
        rrect,
        paint
          ..strokeWidth = 3
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 15));

    //player avatar bg
    final avatarBgRRect = RRect.fromLTRBR(
      _avatarPositions[playerIndex][0],
      _avatarPositions[playerIndex][1],
      _avatarPositions[playerIndex][0] + game.unitSize * 2.75,
      _avatarPositions[playerIndex][1] + game.unitSize * 2.75,
      const Radius.circular(24.0),
    );

    final avatarBgPaint = Paint()
      ..color = playerColors[playerIndex]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawRRect(
      avatarBgRRect,
      avatarBgPaint,
    );
    canvas.drawRRect(
      avatarBgRRect,
      avatarBgPaint
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 15),
    );
  }

  PlayerPin removePin(PlayerPin pin, int homePinIndex) {
    remove(pin);
    _homePins[homePinIndex] = null;
    return pin;
  }

  void addPin(PlayerPin pin) {
    for (int i = 0; i < 4; i++) {
      if (_homePins[i] == null) {
        _homePins[i] = pin
          ..currentPosIndex = -1
          ..position = _homePinLocations[i]
          ..onTap = (event, pin) {
            if (game.dice.value == 6) {
              game.board.addPin(removePin(pin, i));
              game.playerCanMove = false;
            }
          };
        add(_homePins[i]!);
      }
    }
  }
}

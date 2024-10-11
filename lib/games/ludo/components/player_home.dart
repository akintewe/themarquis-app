import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:marquis_v2/games/ludo/components/player_avatar.dart';
import 'package:marquis_v2/games/ludo/components/player_pin.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/models/ludo_session.dart';

class PlayerHome extends PositionComponent with HasGameReference<LudoGame> {
  final int playerIndex;
  final LudoSessionUserStatus userStatus;
  late TextComponent playerName;
  late List<PlayerPin?> _homePins;
  late List<Vector2> _homePinLocations;
  late List<Vector2> _avatarPositions;

  bool get isHomeFull =>
      _homePins[0] != null &&
      _homePins[1] != null &&
      _homePins[2] != null &&
      _homePins[3] != null;

  bool get isHomeEmpty =>
      _homePins[0] == null &&
      _homePins[1] == null &&
      _homePins[2] == null &&
      _homePins[3] == null;

  List<PlayerPin?> get homePins => _homePins;

  List<PlayerPin?> get pinsAtHome =>
      _homePins.where((pin) => pin != null).toList();

  PlayerHome(this.playerIndex, this.userStatus, Vector2 position)
      : super(position: position);

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
        0,
        (event, pin) {
          if (game.dice.value >= 6) {
            // Move in websockets handler
            // game.board.addPin(
            //     removePin(pin, 0)..position = pin.position + position,
            //     location: game.pendingMoves);
            return true;
          } else {
            return false;
          }
        },
      ),
      PlayerPin(
        Vector2(game.unitSize * 2.5, game.unitSize * 1),
        playerIndex,
        1,
        (event, pin) {
          if (game.dice.value >= 6) {
            // game.board.addPin(
            //     removePin(pin, 1)..position = pin.position + position,
            //     location: game.pendingMoves);
            return true;
          } else {
            return false;
          }
        },
      ),
      PlayerPin(
        Vector2(game.unitSize * 1, game.unitSize * 2.2),
        playerIndex,
        2,
        (event, pin) {
          if (game.dice.value >= 6) {
            // game.board.addPin(
            //     removePin(pin, 2)..position = pin.position + position,
            //     location: game.pendingMoves);
            return true;
          } else {
            return false;
          }
        },
      ),
      PlayerPin(
        Vector2(game.unitSize * 2.5, game.unitSize * 2.2),
        playerIndex,
        3,
        (event, pin) {
          if (game.dice.value >= 6) {
            // game.board.addPin(
            //     removePin(pin, 3)..position = pin.position + position,
            //     location: game.pendingMoves);
            return true;
          } else {
            return false;
          }
        },
      ),
    ];

    for (var pin in _homePins) {
      await add(pin!);
    }

    _avatarPositions = [
      Vector2(0, game.unitSize * -4.5), //top left
      Vector2(game.unitSize * 1.25, game.unitSize * -4.5), //top right
      Vector2(game.unitSize * 1.25, game.unitSize * 5), //bottom right
      Vector2(0, game.unitSize * 5), //bottom left
    ];

    //player name
    playerName = TextComponent(
      text: playerIndex == game.userIndex
          ? "You"
          : userStatus.email.split("@").first,
      position: (playerIndex == 0 || playerIndex == 1)
          ? (playerIndex % 2 == 0)
              ? Vector2(size.x / 2, size.y / -2)
              : Vector2(size.x / 0.95, size.y / -2)
          : (playerIndex % 2 == 0)
              ? Vector2(size.x / 0.95, size.y / 0.295) //btm right
              : Vector2(size.x / 2, size.y / 0.295), //btm left
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
    await add(playerName);

    await add(PlayerAvatar(_avatarPositions[playerIndex], playerIndex));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //player home
    final rrect = RRect.fromLTRBR(0, 0, game.unitSize * 4, game.unitSize * 4,
        const Radius.circular(16.0));
    final paint = Paint()
      ..color = game.listOfColors[playerIndex]
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
      ..color = game.listOfColors[playerIndex]
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawRRect(
      avatarBgRRect,
      avatarBgPaint,
    );
    if (game.userIndex == playerIndex) {
      canvas.drawRRect(
        avatarBgRRect,
        avatarBgPaint
          ..strokeWidth = 5
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 15),
      );
    }
  }

  PlayerPin removePin(int homePinIndex) {
    // if (_homePins[homePinIndex]!.isMounted) {
    remove(_homePins[homePinIndex]!);
    // }
    final result = _homePins[homePinIndex]!..position += position;
    _homePins[homePinIndex] = null;
    return result;
  }

  Future<void> returnPin(PlayerPin pin) async {
    _homePins[pin.homeIndex] = pin
      ..onTap = (event, pin) {
        if (game.dice.value >= 6 && game.currentPlayer == pin.playerIndex) {
          return true;
        } else {
          return false;
        }
      }
      ..returnToHome(_homePinLocations[pin.homeIndex]);
    print("Player ${pin.playerIndex} pin ${pin.homeIndex} returned to home");
    await add(_homePins[pin.homeIndex]!);
  }
}

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/components/player_pin.dart';
import 'package:marquis_v2/games/ludo/config.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

final playerFirstTile = {
  0: Vector2(0, 0),
};

class Board extends RectangleComponent with HasGameReference<LudoGame> {
  Board()
      : super(
          paint: Paint()..color = const Color(0xff0f1118),
        );
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    double dxStart = game.unitSize * 0.75;
    double dyStart = center.y - 1.5 * game.unitSize;
    List<int> coloredBox = [1, 6, 7, 8, 9];
    for (var i = 0; i < 15; i++) {
      final x = dxStart + (i % 5) * game.unitSize;
      final y = dyStart + (i ~/ 5) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color =
              coloredBox.contains(i) ? playerColors[0] : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = playerColors[0].withOpacity(0.2),
        );
      }
    }

    dxStart = center.x - 1.5 * game.unitSize;
    dyStart = center.y - 6.75 * game.unitSize;
    coloredBox = [4, 5, 7, 10, 13];
    for (var i = 0; i < 15; i++) {
      final x = dxStart + (i % 3) * game.unitSize;
      final y = dyStart + (i ~/ 3) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color =
              coloredBox.contains(i) ? playerColors[1] : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = playerColors[1].withOpacity(0.2),
        );
      }
    }

    dxStart = center.x - 1.5 * game.unitSize;
    dyStart = center.y + 1.75 * game.unitSize;
    coloredBox = [1, 4, 7, 9, 10];
    for (var i = 0; i < 15; i++) {
      final x = dxStart + (i % 3) * game.unitSize;
      final y = dyStart + (i ~/ 3) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color =
              coloredBox.contains(i) ? playerColors[2] : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = playerColors[2].withOpacity(0.2),
        );
      }
    }

    dxStart = center.x + 1.75 * game.unitSize;
    dyStart = center.y - 1.5 * game.unitSize;
    coloredBox = [5, 6, 7, 8, 13];
    for (var i = 0; i < 15; i++) {
      final x = dxStart + (i % 5) * game.unitSize;
      final y = dyStart + (i ~/ 5) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color =
              coloredBox.contains(i) ? playerColors[3] : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = playerColors[3].withOpacity(0.2),
        );
      }
    }
  }

  PlayerPin? getPinAtPosition(int playerIndex, int positionIndex) {
    for (var pin in children.whereType<PlayerPin>()) {
      if (pin.playerIndex == playerIndex &&
          pin.currentPosIndex == positionIndex) {
        return pin;
      }
    }
    return null;
  }

  void attackPin(PlayerPin pin) {
    pin.currentPosIndex = -1;
    final playerHome = game.playerHomes[pin.playerIndex];
    playerHome.returnPin(pin);
    remove(pin);
  }

  void addPin(PlayerPin pin) {
    add(pin
      ..movePin(0)
      ..onTap = (event, pin) {
        pin.movePin(null);
        return true;
      });
  }
}

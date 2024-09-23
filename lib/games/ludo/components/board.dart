import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/components/player_pin.dart';
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
    List<int> coloredBox = [1, 7, 8, 9, 10, 11];
    for (var i = 0; i < 18; i++) {
      final x = dxStart + (i % 6) * game.unitSize;
      final y = dyStart + (i ~/ 6) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = coloredBox.contains(i)
              ? game.listOfColors[0]
              : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = game.listOfColors[0].withOpacity(0.2),
        );
      }
    }

    dxStart = center.x - 1.5 * game.unitSize;
    dyStart = center.y - 7.75 * game.unitSize;
    coloredBox = [4, 5, 7, 10, 13, 16];
    for (var i = 0; i < 18; i++) {
      final x = dxStart + (i % 3) * game.unitSize;
      final y = dyStart + (i ~/ 3) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = coloredBox.contains(i)
              ? game.listOfColors[1]
              : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = game.listOfColors[1].withOpacity(0.2),
        );
      }
    }
    dxStart = center.x + 1.75 * game.unitSize;
    dyStart = center.y - 1.5 * game.unitSize;
    coloredBox = [6, 7, 8, 9, 10, 16];
    for (var i = 0; i < 18; i++) {
      final x = dxStart + (i % 6) * game.unitSize;
      final y = dyStart + (i ~/ 6) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = coloredBox.contains(i)
              ? game.listOfColors[2]
              : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = game.listOfColors[2].withOpacity(0.2),
        );
      }
    }

    dxStart = center.x - 1.5 * game.unitSize;
    dyStart = center.y + 1.75 * game.unitSize;
    coloredBox = [1, 4, 7, 10, 12, 13];
    for (var i = 0; i < 18; i++) {
      final x = dxStart + (i % 3) * game.unitSize;
      final y = dyStart + (i ~/ 3) * game.unitSize;
      final rrect = RRect.fromLTRBR(x, y, x + game.unitSize, y + game.unitSize,
          const Radius.circular(3.0));
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = coloredBox.contains(i)
              ? game.listOfColors[3]
              : const Color(0xff606060)
          ..style = PaintingStyle.stroke,
      );
      if (coloredBox.contains(i)) {
        canvas.drawRRect(
          rrect,
          Paint()..color = game.listOfColors[3].withOpacity(0.2),
        );
      }
    }
  }

  int convertToGlobalIndex(int playerIndex, int positionIndex) {
    //relative to player 1
    switch (playerIndex) {
      case 0:
        return positionIndex;
      case 1:
        return (positionIndex + 13) % 52;
      case 2:
        return (positionIndex + 26) % 52;
      case 3:
        return (positionIndex + 39) % 52;
      default:
        return 0;
    }
  }

  List<PlayerPin> getPinsAtPosition(int playerIndex, int positionIndex) {
    final List<PlayerPin> results = [];
    for (var pin in children.whereType<PlayerPin>()) {
      if (convertToGlobalIndex(pin.playerIndex, pin.currentPosIndex) ==
          convertToGlobalIndex(playerIndex, positionIndex)) {
        results.add(pin);
      }
    }
    return results;
  }

  PlayerPin? getPinWithIndex(int playerIndex, int pinIndex) {
    for (var pin in children.whereType<PlayerPin>()) {
      if (pin.playerIndex == playerIndex && pin.homeIndex == pinIndex) {
        return pin;
      }
    }
    return null;
  }

  List<PlayerPin> getPlayerPinsOnBoard(int playerIndex) {
    final List<PlayerPin> results = [];
    for (var pin in children.whereType<PlayerPin>()) {
      if (pin.playerIndex == playerIndex) {
        results.add(pin);
      }
    }
    return results;
  }

  void attackPin(PlayerPin pin) {
    pin.currentPosIndex = -1;
    final playerHome = game.playerHomes[pin.playerIndex];
    remove(pin);
    playerHome.returnPin(pin);
  }

  Future<void> addPin(PlayerPin pin, {int location = 0}) async {
    await add(pin
      ..onTap = (event, pin) {
        if ((pin.currentPosIndex >= 0 || game.dice.value == 6) &&
            (pin.currentPosIndex + game.dice.value <= 56)) {
          // pin.movePin(null);
          return true;
        }
        return false;
      });
    print("moving pin");
    await pin.movePin(location);
  }
}

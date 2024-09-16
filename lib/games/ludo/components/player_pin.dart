import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/config.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

Map<int, List<double>> spriteLocationMap = {
  0: [1, 1, 366, 590], // x, y, w, h
  1: [369, 1, 366, 590],
  3: [737, 431, 290, 472],
  2: [737, 1, 266, 428],
};

class PlayerPin extends SpriteComponent
    with TapCallbacks, HasGameReference<LudoGame> {
  bool Function(TapUpEvent event, PlayerPin pin) onTap;
  final int playerIndex;
  final int homeIndex;
  int currentPosIndex = -1; // Ensure this is set to -1 initially
  PlayerPin(Vector2 position, this.playerIndex, this.homeIndex, this.onTap)
      : super(
          position: position,
          sprite: Sprite(
            Flame.images.fromCache('spritesheet.png'),
            srcPosition: Vector2(spriteLocationMap[playerIndex]![0],
                spriteLocationMap[playerIndex]![1]),
            srcSize: Vector2(spriteLocationMap[playerIndex]![2],
                spriteLocationMap[playerIndex]![3]),
          ),
        );

  @override
  FutureOr<void> onLoad() {
    size = Vector2(game.unitSize * 0.5, game.unitSize * 0.8);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) async {
    if (game.currentPlayer == playerIndex && game.playerCanMove) {
      if (onTap(event, this)) {
        game.playerCanMove = false;
        try {
          await game.playMove(homeIndex);
          game.nextPlayer();
        } catch (e) {
          game.playerCanMove = true;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (game.currentPlayer == playerIndex &&
        game.playerCanMove &&
        (currentPosIndex >= 0 || game.dice.value == 6) &&
        (currentPosIndex + game.dice.value <= 47)) {
      final paint = Paint()
        ..color = game.listOfColors[playerIndex]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      final radius = size.x * 0.85;
      final center = Offset(size.x / 2, size.y / 2);

      canvas.drawCircle(center, radius, paint);
    }
  }

  void returnToHome(Vector2 homePosition) {
    currentPosIndex = -1;
    add(MoveEffect.to(
      homePosition,
      EffectController(duration: 0.3, curve: Curves.easeInOut),
      onComplete: () {
        position = homePosition;
      },
    ));
  }

  void movePin(int? index) {
    int startIndex = currentPosIndex;
    int targetIndex;

    List<MoveEffect> moveEffects = [];

    // Handle initial move from home
    if (startIndex == -1) {
      if (game.dice.value == 6) {
        currentPosIndex = 0;
        Vector2 startPosition = routeIndexToPos(playerIndex, 0);
        moveEffects.add(MoveEffect.to(
          startPosition,
          EffectController(duration: 0.3, curve: Curves.easeInOut),
          onComplete: () {
            position = startPosition;
          },
        ));
        startIndex = 0;
      }
      targetIndex = index ?? 0;
    } else if (index == null) {
      targetIndex = currentPosIndex + game.dice.value;
    } else {
      targetIndex = index;
    }

    if (targetIndex == 47) {
      game.destination.addPin(this);
      game.board.remove(this);
      return;
    }

    // Ensure we're actually moving
    if (targetIndex <= startIndex) {
      print(
          "Invalid move: target index ($targetIndex) is not greater than start index ($startIndex)");
      return;
    }

    print("Player $playerIndex moving to position $targetIndex");

    currentPosIndex = targetIndex;

    // Check for attack
    // final pinsAtTarget = game.board.getPinsAtPosition(playerIndex, targetIndex);
    // PlayerPin? attackedPin = pinsAtTarget.isEmpty ? null : pinsAtTarget.first;

    // if (attackedPin != null && attackedPin.playerIndex != playerIndex) {
    //   game.board.attackPin(attackedPin);
    //   print(
    //       "Player $playerIndex attacked player ${attackedPin.playerIndex} at position $targetIndex");
    // }
    // if (pinsAtTarget.isNotEmpty) {
    //   for (var attackedPin in pinsAtTarget) {
    //     game.board.attackPin(attackedPin);
    //     print(
    //         "Player $playerIndex attacked player ${attackedPin.playerIndex} at position $targetIndex");
    //   }
    // }

    // Create a list of move effects for each step

    for (int i = startIndex + 1; i <= targetIndex; i++) {
      // final pinsAtTarget = game.board.getPinsAtPosition(playerIndex, i);
      // if (pinsAtTarget.length > 1) {
      //   currentPosIndex = i;
      //   break;
      // }
      final newPosition = routeIndexToPos(playerIndex, i);
      moveEffects.add(
        MoveEffect.to(
          newPosition,
          EffectController(
            duration: 0.1,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }

    if (moveEffects.isNotEmpty) {
      moveEffects.last.onComplete = () {
        position = moveEffects.last.target.position;
      };
      // Add sequential effect to combine all move effects
      add(SequenceEffect(moveEffects));
    } else {
      print("No movement required: start and target positions are the same");
    }
  }

  Vector2 routeIndexToPos(int playerIndex, int positionIndex) {
    double x = 0, y = 0;
    final coords = playerRouteMap[playerIndex]![positionIndex];
    // print("Player $playerIndex moving to position $positionIndex: ($x, $y)");
    final index = coords[1];
    switch (coords[0]) {
      case 0:
        double dxStart = game.unitSize * 0.75;
        double dyStart = game.center.y - 1.5 * game.unitSize;
        x = dxStart + (index % 5 + 0.24) * game.unitSize;
        y = dyStart + (index ~/ 5 + 0.1) * game.unitSize;
        break;
      case 1:
        double dxStart = game.center.x - 1.5 * game.unitSize;
        double dyStart = game.center.y - 6.75 * game.unitSize;
        x = dxStart + (index % 3 + 0.24) * game.unitSize;
        y = dyStart + (index ~/ 3 + 0.1) * game.unitSize;
        break;
      case 2:
        double dxStart = game.center.x + 1.75 * game.unitSize;
        double dyStart = game.center.y - 1.5 * game.unitSize;
        x = dxStart + (index % 5 + 0.24) * game.unitSize;
        y = dyStart + (index ~/ 5 + 0.1) * game.unitSize;
        break;
      case 3:
        double dxStart = game.center.x - 1.5 * game.unitSize;
        double dyStart = game.center.y + 1.75 * game.unitSize;
        x = dxStart + (index % 3 + 0.24) * game.unitSize;
        y = dyStart + (index ~/ 3 + 0.1) * game.unitSize;
        break;
    }
    return Vector2(x, y);
  }
}

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class Dice extends PositionComponent
    with TapCallbacks, HasGameReference<LudoGame> {
  int value = 1;
  bool _isLoading = false;
  late SpriteSheet diceSpriteSheet;
  Sprite? currentSprite;

  final Random random = Random();

  set isLoading(bool value) {
    _isLoading = value;
    update(0);
  }

  Dice({required Vector2 size, required Vector2 position})
      : super(
          size: size,
          position: position,
          // paint: Paint()..color = Colors.white,
          anchor: Anchor.center,
        );
  @override
  Future<void> onLoad() async {
    super.onLoad();
    diceSpriteSheet = SpriteSheet(
      image: await game.images.load('dice_interface.png'),
      srcSize: Vector2(267, 267), //1602 * 267
    );
    currentSprite = diceSpriteSheet.getSprite(0, 0); // Start with face 1
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_isLoading) {
      final center = Offset(size.x / 2, size.y / 2);
      final radius = min(size.x, size.y) / 4;
      final paint = Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      final sweepAngle =
          2 * pi * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        sweepAngle,
        false,
        paint,
      );
    } else {
      currentSprite = diceSpriteSheet.getSprite(
          0, min(value - 1, 5)); // value between 1 and 6
      if (currentSprite != null) {
        currentSprite!.render(
          canvas,
          size: size, // Draw sprite to fill the dice component's size
        );
      } else {
        final paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        final rect = Rect.fromLTWH(0, 0, size.x, size.y);
        canvas.drawRect(rect, paint);

        final borderPaint = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

        canvas.drawRect(rect, borderPaint);
      }
    }
  }

  Future<void> roll() async {
    _isLoading = true;
    // Request a redraw to show the loading state
    update(0);
    try {
      final moveResults = await game.generateMove();
      value = moveResults.reduce((a, b) => a + b);
      // if (moveResults.length > 1) {
      //   game.pendingMoves =  - value;
      // }
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    update(0);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    if (game.currentPlayer == game.userIndex) {
      game.rollDice();
    }
  }
}

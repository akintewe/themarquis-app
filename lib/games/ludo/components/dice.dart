import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class Dice extends RectangleComponent
    with TapCallbacks, HasGameReference<LudoGame> {
  int value = 6;
  bool _isLoading = false;
  final Random random = Random();

  Dice({required Vector2 size, required Vector2 position})
      : super(
            size: size,
            position: position,
            paint: Paint()..color = Colors.white,
            anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isLoading) {
      final center = Offset(size.x / 2, size.y / 2);
      final radius = min(size.x, size.y) / 4;
      final paint = Paint()
        ..color = Colors.black
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
      final textPainter = TextPainter(
        text: TextSpan(
            text: value.toString(),
            style: const TextStyle(fontSize: 50, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(size.x / 2 - textPainter.width / 2,
              size.y / 2 - textPainter.height / 2));
    }
  }

  Future<void> roll() async {
    _isLoading = true;
    // Request a redraw to show the loading state
    game.update(0);

    final moveResults = await game.generateMove();
    value = moveResults[0];
    if (moveResults.length > 1) {
      game.pendingMoves = moveResults.reduce((a, b) => a + b) - value;
    }

    _isLoading = false;
    // Request another redraw to show the new value
    game.update(0);
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (game.currentPlayer == game.userIndex) {
      game.rollDice();
    }
  }
}

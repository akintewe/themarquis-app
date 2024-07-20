import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class Dice extends RectangleComponent
    with TapCallbacks, HasGameReference<LudoGame> {
  int value = 6;
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

  void roll() {
    value = random.nextInt(6) + 1;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    game.rollDice();
  }

  void animate() {
    add(
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(duration: 0.2, reverseDuration: 0.2, infinite: false),
      ),
    );
  }
}

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

enum DiceState {
  inactive,
  preparing,
  active,
  rollingDice,
  rolledDice,
  playingMove,
}

class Dice extends PositionComponent
    with TapCallbacks, HasGameReference<LudoGame> {
  List<int> _values = [1];
  DiceState _state = DiceState.inactive;
  late SpriteSheet diceSpriteSheet;
  List<Sprite?> _currentSprites = [];
  double _emphasisAngle = 0;

  final Random random = Random();

  int get value => _values.fold(0, (sum, value) => sum + value);
  List<int> get values => _values;
  set values(List<int> newValues) {
    _values = newValues;
    _currentSprites = values
        .map((value) => diceSpriteSheet.getSprite(0, min(value - 1, 5)))
        .toList();
    update(0);
  }

  DiceState get state => _state;
  set state(DiceState newState) {
    _state = newState;
    update(0);
  }

  Dice({required Vector2 size, required Vector2 position})
      : super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    diceSpriteSheet = SpriteSheet(
      image: await game.images.load('dice_interface.png'),
      srcSize: Vector2(267, 267),
    );
    _currentSprites = [diceSpriteSheet.getSprite(0, 0)];
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_state == DiceState.active) {
      _emphasisAngle += dt * 5; // Adjust speed as needed
      if (_emphasisAngle > 2 * pi) {
        _emphasisAngle -= 2 * pi;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_state == DiceState.active) {
      _renderEmphasis(canvas);
    }

    switch (_state) {
      case DiceState.inactive:
      case DiceState.active:
      case DiceState.rolledDice:
        _renderDice(canvas);
        break;
      case DiceState.rollingDice:
        _renderLoadingIndicator(canvas);
        break;
      case DiceState.playingMove:
      case DiceState.preparing:
        _renderDice(canvas);
        _renderLoadingIndicator(canvas);
        break;
    }

    _renderStateIndicator(canvas);
  }

  void _renderEmphasis(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final radius = min(size.x, size.y) / 2 + 10;
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (int i = 0; i < 4; i++) {
      final startAngle = _emphasisAngle + i * pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        pi / 4,
        false,
        paint,
      );
    }
  }

  void _renderLoadingIndicator(Canvas canvas) {
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
  }

  void _renderDice(Canvas canvas) {
    final diceCount = _currentSprites.length;
    final spacing = 10.0; // Space between dice
    final totalSpacing = (diceCount - 1) * spacing;
    final diceWidth = (size.x - totalSpacing) / diceCount;
    final diceSize = Vector2(diceWidth, diceWidth); // Make dice square

    for (int i = 0; i < diceCount; i++) {
      final sprite = _currentSprites[i];
      final xPosition = i * (diceWidth + spacing);
      final yPosition = (size.y - diceWidth) / 2; // Center vertically

      if (sprite != null) {
        sprite.render(
          canvas,
          position: Vector2(xPosition, yPosition),
          size: diceSize,
        );
      } else {
        _renderDefaultDice(canvas, xPosition, yPosition, diceSize);
      }
    }
  }

  void _renderDefaultDice(Canvas canvas, double x, double y, Vector2 diceSize) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(x, y, diceSize.x, diceSize.y);
    canvas.drawRect(rect, paint);

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(rect, borderPaint);
  }

  void _renderStateIndicator(Canvas canvas) {
    final indicatorPaint = Paint()..style = PaintingStyle.fill;

    switch (_state) {
      case DiceState.inactive:
        indicatorPaint.color = Colors.red;
        break;
      case DiceState.active:
      case DiceState.preparing:
        indicatorPaint.color = Colors.green;
        break;
      case DiceState.rollingDice:
        indicatorPaint.color = Colors.yellow;
        break;
      case DiceState.rolledDice:
        indicatorPaint.color = Colors.orange;
        break;
      case DiceState.playingMove:
        indicatorPaint.color = Colors.blue;
        break;
    }

    canvas.drawCircle(Offset(size.x - 10, 10), 5, indicatorPaint);
  }

  Future<void> roll() async {
    state = DiceState.rollingDice;
    try {
      final moveResults = await game.generateMove();
      _values = moveResults;
      _currentSprites = _values
          .map((value) => diceSpriteSheet.getSprite(0, min(value - 1, 5)))
          .toList();
      state = DiceState.rolledDice;
    } catch (e) {
      print(e);
      state = DiceState.active;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);

    if (_state == DiceState.active) {
      game.rollDice();
    }
  }

  void setInactive() {
    state = DiceState.inactive;
  }

  void setActive() {
    state = DiceState.active;
  }

  void setRolledDice() {
    state = DiceState.rolledDice;
  }

  void setPlayingMove() {
    state = DiceState.playingMove;
  }
}

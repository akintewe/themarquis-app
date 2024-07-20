import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/components/player_pin.dart';
import 'package:marquis_v2/games/ludo/config.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class Destination extends PositionComponent with HasGameReference<LudoGame> {
  Destination()
      : super(
          anchor: Anchor.center,
        );

  late Map<int, List<BarComponent>> _bars;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.unitSize * 2.5, game.unitSize * 2.5);
    position = game.size / 2;

    _bars = {
      0: [
        BarComponent(
          playerIndex: 0,
          position: Vector2(0.1875 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 1.8 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(0.4375 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 1.4 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(0.6875 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 1 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(0.9375 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 0.5 * game.unitSize),
        ),
      ],
      1: [
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 0.1875 * game.unitSize),
          size: Vector2(1.8 * game.unitSize, 0.125 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 0.4375 * game.unitSize),
          size: Vector2(1.4 * game.unitSize, 0.125 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 0.6875 * game.unitSize),
          size: Vector2(1 * game.unitSize, 0.125 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 0.9375 * game.unitSize),
          size: Vector2(0.5 * game.unitSize, 0.125 * game.unitSize),
        ),
      ],
      2: [
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 2.3125 * game.unitSize),
          size: Vector2(1.8 * game.unitSize, 0.125 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 2.0625 * game.unitSize),
          size: Vector2(1.4 * game.unitSize, 0.125 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 1.8125 * game.unitSize),
          size: Vector2(1 * game.unitSize, 0.125 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.25 * game.unitSize, 1.5625 * game.unitSize),
          size: Vector2(0.5 * game.unitSize, 0.125 * game.unitSize),
        ),
      ],
      3: [
        BarComponent(
          playerIndex: 0,
          position: Vector2(2.3125 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 1.8 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(2.0625 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 1.4 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.8125 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 1 * game.unitSize),
        ),
        BarComponent(
          playerIndex: 0,
          position: Vector2(1.5625 * game.unitSize, 1.25 * game.unitSize),
          size: Vector2(0.125 * game.unitSize, 0.5 * game.unitSize),
        ),
      ]
    };
    for (var bars in _bars.values) {
      for (var bar in bars) {
        add(bar);
      }
    }
  }

  final Map<int, List<PlayerPin>> _players = {0: [], 1: [], 2: [], 3: []};

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, game.unitSize * 2.5, game.unitSize * 2.5,
            const Radius.circular(6.0)),
        Paint()
          ..color = const Color(0xff4c4c4c)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
  }

  void addPin(PlayerPin pin) {
    _bars[pin.playerIndex]![(_players[pin.playerIndex]!..add(pin)).length]
        .lightUp();
  }
}

class BarComponent extends PositionComponent {
  final int playerIndex;
  BarComponent({
    required this.playerIndex,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
        RRect.fromRectAndRadius(size.toRect(), const Radius.circular(5)),
        Paint()..color = const Color(0xff3a3a3a));
  }

  void lightUp() {
    add(
      ColorEffect(
        playerColors[playerIndex],
        EffectController(
          duration: 1,
        ),
      ),
    );
  }
}

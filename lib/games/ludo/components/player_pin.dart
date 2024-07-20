import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:marquis_v2/games/ludo/config.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

Map<int, List<double>> spriteLocationMap = {
  0: [1, 1, 366, 590], // x, y, w, h
  1: [369, 1, 366, 590],
  2: [737, 431, 290, 472],
  3: [737, 1, 266, 428],
};

class PlayerPin extends SpriteComponent
    with TapCallbacks, HasGameReference<LudoGame> {
  Function(TapUpEvent event, PlayerPin pin) onTap;
  final int playerIndex;
  int currentPosIndex = -1;
  PlayerPin(Vector2 position, this.playerIndex, this.onTap)
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
  void onTapUp(TapUpEvent event) {
    if (game.currentPlayer == playerIndex && game.playerCanMove) {
      onTap(event, this);
      game.nextPlayer();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (game.currentPlayer == playerIndex &&
        game.playerCanMove &&
        (currentPosIndex >= 0 || game.dice.value == 6)) {
      final paint = Paint()
        ..color = playerColors[playerIndex]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      final radius = size.x * 0.85;
      final center = Offset(size.x / 2, size.y / 2);

      canvas.drawCircle(center, radius, paint);
    }
  }

  void movePin(int? index) {
    if (index == null) {
      currentPosIndex += game.dice.value;
    } else {
      currentPosIndex = index;
    }
    if (currentPosIndex > 46) {
      game.destination;
      game.board.remove(this);
    } else {
      position = routeIndexToPos(playerIndex, currentPosIndex);
    }
  }

  Vector2 routeIndexToPos(int playerIndex, int positionIndex) {
    double x = 0, y = 0;
    final coords = playerRouteMap[playerIndex]![positionIndex];
    print("moving to $coords");
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
        double dxStart = game.center.x - 1.5 * game.unitSize;
        double dyStart = game.center.y + 1.75 * game.unitSize;
        x = dxStart + (index % 3 + 0.24) * game.unitSize;
        y = dyStart + (index ~/ 3 + 0.1) * game.unitSize;
        break;
      case 3:
        double dxStart = game.center.x + 1.75 * game.unitSize;
        double dyStart = game.center.y - 1.5 * game.unitSize;
        x = dxStart + (index % 5 + 0.24) * game.unitSize;
        y = dyStart + (index ~/ 5 + 0.1) * game.unitSize;
        break;
    }
    return Vector2(x, y);
  }
}

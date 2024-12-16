import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/checkers_game.dart';

class UserStatsComponent extends PositionComponent with HasGameReference<CheckersGame> {
  late TextComponent player1Name;
  late TextComponent player2Name;
  late TextComponent capturedPieces1;
  late TextComponent capturedPieces2;

  @override
  Future<void> onLoad() async {
    player1Name = TextComponent(
      text: 'Player 1',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
    player1Name.position = Vector2(20, 20);
    await add(player1Name);

    player2Name = TextComponent(
      text: 'Player 2',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
    player2Name.position = Vector2(20, game.height - 40);
    await add(player2Name);

    // Add captured pieces counters
    capturedPieces1 = TextComponent(
      text: 'Captured: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    capturedPieces1.position = Vector2(20, 50);
    await add(capturedPieces1);

    capturedPieces2 = TextComponent(
      text: 'Captured: 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    capturedPieces2.position = Vector2(20, game.height - 70);
    await add(capturedPieces2);
  }
} 
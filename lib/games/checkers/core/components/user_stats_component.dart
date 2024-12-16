import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import '../game/checkers_game.dart';
import 'dart:math';

class UserStatsComponent extends PositionComponent with HasGameReference<CheckersGame> {
  late TextComponent player1Name;
  late TextComponent player2Name;
  late SpriteComponent player1Avatar;
  late SpriteComponent player2Avatar;
  
  @override
  Future<void> onLoad() async {
    // Load sprites
    final topAvatar = await Sprite.load('Frame 2085661553.png');
    final bottomAvatar = await Sprite.load('Frame 2085661554.png');
    final blackPieceSprite = await Sprite.load('blackchecker.png');
    final whitePieceSprite = await Sprite.load('whitechecker.png');
    final queenSprite = await Sprite.load('queen.png');

    // Top player stats sections with reduced spacing
    await _createStatsContainer(
      text: "LOST PIECES",
      value: "10",
      position: Vector2(15, 90),
      icon: blackPieceSprite,
      containerSize: Vector2(80, 60),
    );

    await _createStatsContainer(
      text: "WIN PIECES",
      value: "9",
      position: Vector2(130, 90),
      icon: blackPieceSprite,
      containerSize: Vector2(80, 60),
    );

    await _createStatsContainer(
      text: "QUEENS",
      value: "2",
      position: Vector2(240, 90),
      icon: queenSprite,
      containerSize: Vector2(80, 60),
    );

    // Top player name and avatar
    player1Name = TextComponent(
      text: 'VYCHU...',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    player1Name.position = Vector2(340,70);
    await add(player1Name);

    player1Avatar = SpriteComponent(
      sprite: topAvatar,
      position: Vector2(340, 90),
      size: Vector2(60, 60),
    );
    await add(player1Avatar);

    // Bottom player name and avatar (starting from left)
    player2Name = TextComponent(
      text: 'SOOBIN...',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    player2Name.position = Vector2(15, game.height - 210);
    await add(player2Name);

    player2Avatar = SpriteComponent(
      sprite: bottomAvatar,
      position: Vector2(15, game.height - 190),
      size: Vector2(60, 60),
    );
    await add(player2Avatar);

    // Bottom player stats sections with reduced spacing (following avatar)
    await _createStatsContainer(
      text: "LOST PIECES",
      value: "2",
      position: Vector2(100, game.height - 190),
      icon: whitePieceSprite,
      containerSize: Vector2(80, 60),
    );

    await _createStatsContainer(
      text: "WIN PIECES",
      value: "1",
      position: Vector2(215, game.height - 190),
      icon: whitePieceSprite,
      containerSize: Vector2(80, 60),
    );

    await _createStatsContainer(
      text: "QUEENS",
      value: "0",
      position: Vector2(320, game.height - 190),
      icon: queenSprite,
      containerSize: Vector2(80, 60),
    );

  
  }

  Future<void> _createStatsContainer({
    required String text,
    required String value,
    required Vector2 position,
    required Sprite icon,
    required Vector2 containerSize,
    bool isBottom = false,
  }) async {
    // Stats label ABOVE container
    final label = TextComponent(
      text: text,
      
      textRenderer: TextPaint(
        style: const TextStyle(
          
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
    label.position = position + Vector2(5, -20); // Position above container
    await add(label);

    // Container background
    final container = RectangleComponent(
      position: position,
      size: containerSize,
      paint: Paint()..color = const Color(0xFF442916).withOpacity(0.5),
    );
    await add(container);

    // Stats value and icon inside container
    final valueComponent = TextComponent(
      text: value,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    valueComponent.position = position + Vector2(10, 20);
    await add(valueComponent);

    final iconComponent = SpriteComponent(
      sprite: icon,
      position: position + Vector2(45, 20),
      size: Vector2(15, 15),
    );
    await add(iconComponent);
  }

  void updateStats({
    required int playerIndex,
    int? lostPieces,
    int? winPieces,
    int? queens,
  }) {
    if (playerIndex == 0) {
      // Update top player stats
      if (lostPieces != null) _updateStatValue("LOST PIECES", lostPieces.toString(), false);
      if (winPieces != null) _updateStatValue("WIN PIECES", winPieces.toString(), false);
      if (queens != null) _updateStatValue("QUEENS", queens.toString(), false);
    } else {
      // Update bottom player stats
      if (lostPieces != null) _updateStatValue("LOST PIECES", lostPieces.toString(), true);
      if (winPieces != null) _updateStatValue("WIN PIECES", winPieces.toString(), true);
      if (queens != null) _updateStatValue("QUEENS", queens.toString(), true);
    }
  }

  void _updateStatValue(String statName, String newValue, bool isBottom) {
    // Implementation to update the specific stat text component
    // You'll need to store references to these text components when creating them
  }

  void updateRandomStats() {
    // Generate random stats for both players
    final random = Random();
    updateStats(
      playerIndex: 0,
      lostPieces: random.nextInt(12),
      winPieces: random.nextInt(12),
      queens: random.nextInt(4),
    );
    updateStats(
      playerIndex: 1,
      lostPieces: random.nextInt(12),
      winPieces: random.nextInt(12),
      queens: random.nextInt(4),
    );
  }
} 
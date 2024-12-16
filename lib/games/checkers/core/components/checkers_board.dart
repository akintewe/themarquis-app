import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquis_v2/games/checkers/core/components/checkers_pin.dart';
import '../game/checkers_game.dart';

class CheckersBoard extends RectangleComponent with HasGameReference<CheckersGame> {
  static const int BOARD_SIZE = 8;
  late PictureInfo blackPinSprite;
  late PictureInfo whitePinSprite;
  
  CheckersBoard() : super(
    paint: Paint()..color = Colors.transparent,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2.all(game.width * 0.8);
    
    // Load the SVG sprites
    final blackData = await rootBundle.load('assets/images/blackchecker.svg');
    final whiteData = await rootBundle.load('assets/images/whitechecker.svg');
    
    blackPinSprite = await vg.loadPicture(
      SvgStringLoader(String.fromCharCodes(blackData.buffer.asUint8List())),
      null,
    );
    whitePinSprite = await vg.loadPicture(
      SvgStringLoader(String.fromCharCodes(whiteData.buffer.asUint8List())),
      null,
    );
  }

  @override
  void render(Canvas canvas) {
    final squareSize = size.x / BOARD_SIZE;
    final pinSize = squareSize * 0.8;
    
    // Draw the background container with border radius and larger padding
    final boardBackground = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        -squareSize * 0.3,  // Increased padding (30% of square size)
        -squareSize * 0.3,  // Increased padding (30% of square size)
        size.x + squareSize * 0.6,  // Added padding to both sides
        size.y + squareSize * 0.6,  // Added padding to both sides
      ),
      const Radius.circular(12),
    );
    
    canvas.drawRRect(
      boardBackground,
      Paint()..color = const Color.fromRGBO(68, 41, 22, 1),
    );
    
    // Draw the 8x8 board with rounded corners
    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int col = 0; col < BOARD_SIZE; col++) {
        final isBlackSquare = (row + col) % 2 == 1;
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            col * squareSize,
            row * squareSize,
            squareSize,
            squareSize,
          ),
          const Radius.circular(3),
        );
        
        canvas.drawRRect(
          rect,
          Paint()..color = isBlackSquare 
              ? const Color.fromRGBO(101, 58, 12, 1)    // Dark brown
              : const Color.fromRGBO(243, 180, 110, 1) // Light brown
        );
      }
    }

    // Define positions for black pieces
    final blackPositions = [
      [0, 2, 4, 6],     // Row 0: 4 pieces
      [1, 3, 5, 7],     // Row 1: 4 pieces
      [0, 2, 4, 6],     // Row 2: 4 pieces
    ];

    // Draw black pieces
    for (int row = 0; row < 3; row++) {
      for (int col in blackPositions[row]) {
        canvas.save();
        canvas.translate(
          col * squareSize + squareSize / 2,
          row * squareSize + squareSize / 2,
        );
        
        canvas.scale(
          pinSize / blackPinSprite.size.width,
          pinSize / blackPinSprite.size.height,
        );
        
        canvas.translate(
          -blackPinSprite.size.width / 2,
          -blackPinSprite.size.height / 2,
        );
        
        canvas.drawPicture(blackPinSprite.picture);
        canvas.restore();
      }
    }

    // Define positions for white pieces
    final whitePositions = [
      [1, 3, 5, 7],     // Row 5: 4 pieces
      [0, 2, 4, 6],     // Row 6: 4 pieces
      [1, 3, 5, 7],     // Row 7: 4 pieces
    ];

    // Draw white pieces
    for (int row = 0; row < 3; row++) {
      for (int col in whitePositions[row]) {
        canvas.save();
        canvas.translate(
          col * squareSize + squareSize / 2,
          (BOARD_SIZE - 3 + row) * squareSize + squareSize / 2,
        );
        
        canvas.scale(
          pinSize / whitePinSprite.size.width,
          pinSize / whitePinSprite.size.height,
        );
        
        canvas.translate(
          -whitePinSprite.size.width / 2,
          -whitePinSprite.size.height / 2,
        );
        
        canvas.drawPicture(whitePinSprite.picture);
        canvas.restore();
      }
    }
  }
} 
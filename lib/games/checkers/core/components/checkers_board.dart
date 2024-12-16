import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquis_v2/games/checkers/core/components/checkers_pin.dart';
import '../game/checkers_game.dart';

class CheckersBoard extends RectangleComponent with HasGameReference<CheckersGame>, TapCallbacks {
  static const int BOARD_SIZE = 8;
  late PictureInfo blackPinSprite;
  late PictureInfo whitePinSprite;
  
  // Track game state
  CheckersPin? selectedPiece;
  List<Vector2> validMoves = [];
  List<List<CheckersPin?>> pieces = List.generate(
    BOARD_SIZE, 
    (_) => List.filled(BOARD_SIZE, null)
  );
  
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

    // Highlight valid moves if a piece is selected
    if (selectedPiece != null) {
      for (final move in validMoves) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            move.x * squareSize,
            move.y * squareSize,
            squareSize,
            squareSize,
          ),
          const Radius.circular(3),
        );
        
        canvas.drawRRect(
          rect,
          Paint()
            ..color = const Color.fromRGBO(76, 175, 80, 0.5)  // Green highlight
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool onTapUp(TapUpEvent event) {
    final squareSize = size.x / BOARD_SIZE;
    final col = (event.canvasPosition.x / squareSize).floor();
    final row = (event.canvasPosition.y / squareSize).floor();

    if (col < 0 || col >= BOARD_SIZE || row < 0 || row >= BOARD_SIZE) return false;

    if (selectedPiece == null) {
      // Select piece
      final piece = pieces[row][col];
      if (piece != null) {
        selectedPiece = piece;
        validMoves = getValidMoves(row, col);
      }
    } else {
      // Try to move piece
      final targetPos = Vector2(col.toDouble(), row.toDouble());
      if (validMoves.contains(targetPos)) {
        movePiece(selectedPiece!, row, col);
      }
      // Clear selection
      selectedPiece = null;
      validMoves.clear();
    }
    
    return false;
  }

  List<Vector2> getValidMoves(int row, int col) {
    List<Vector2> moves = [];
    final piece = pieces[row][col];
    if (piece == null) return moves;

    // Regular moves (diagonal forward)
    final directions = piece.isBlack ? [1] : [-1];  // Black moves down, white moves up
    
    for (final dRow in directions) {
      for (final dCol in [-1, 1]) {  // Left and right diagonals
        final newRow = row + dRow;
        final newCol = col + dCol;
        
        // Check regular move
        if (isValidPosition(newRow, newCol) && pieces[newRow][newCol] == null) {
          moves.add(Vector2(newCol.toDouble(), newRow.toDouble()));
        }
        
        // Check jump move
        final jumpRow = row + dRow * 2;
        final jumpCol = col + dCol * 2;
        if (isValidPosition(jumpRow, jumpCol) && 
            pieces[jumpRow][jumpCol] == null && 
            pieces[newRow][newCol]?.isBlack != piece.isBlack) {
          moves.add(Vector2(jumpCol.toDouble(), jumpRow.toDouble()));
        }
      }
    }

    return moves;
  }

  bool isValidPosition(int row, int col) {
    return row >= 0 && row < BOARD_SIZE && col >= 0 && col < BOARD_SIZE;
  }

  void movePiece(CheckersPin piece, int newRow, int col) {
    final oldRow = piece.position.y ~/ (size.x / BOARD_SIZE);
    final oldCol = piece.position.x ~/ (size.x / BOARD_SIZE);
    
    // Update board state
    pieces[oldRow][oldCol] = null;
    pieces[newRow][col] = piece;
    
    // Check if this was a jump move
    if ((newRow - oldRow).abs() == 2) {
      final capturedRow = (newRow + oldRow) ~/ 2;
      final capturedCol = (col + oldCol) ~/ 2;
      pieces[capturedRow][capturedCol] = null;
    }
    
    // Move the piece
    piece.position = Vector2(
      col * size.x / BOARD_SIZE + size.x / BOARD_SIZE / 2,
      newRow * size.x / BOARD_SIZE + size.x / BOARD_SIZE / 2,
    );
  }
} 
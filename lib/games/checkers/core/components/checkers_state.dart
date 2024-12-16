import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game/checkers_game.dart';
import 'checkers_pin.dart';

class CheckersState extends Component with HasGameReference<CheckersGame> {
  CheckersPin? selectedPiece;
  List<Vector2> validMoves = [];
  bool isBlackTurn = true;
  
  void selectPiece(CheckersPin piece, Vector2 position) {
    selectedPiece = piece;
    validMoves = getValidMoves(position);
  }
  
  void clearSelection() {
    selectedPiece = null;
    validMoves.clear();
  }
  
  List<Vector2> getValidMoves(Vector2 position) {
    List<Vector2> moves = [];
    // Add basic moves (diagonally forward)
    final direction = selectedPiece!.isBlack ? 1 : -1;
    
    // Left and right diagonal moves
    moves.add(position + Vector2(-1.0, direction.toDouble()));
    moves.add(position + Vector2(1.0, direction.toDouble()));
    
    return moves.where((move) => 
      move.x >= 0 && move.x < 8 && 
      move.y >= 0 && move.y < 8
    ).toList();
  }
  
  void switchTurn() {
    isBlackTurn = !isBlackTurn;
    game.currentPlayer = isBlackTurn ? 0 : 1;
    game.turnText.text = '${isBlackTurn ? 'Black' : 'White'}\'s Turn';
  }
} 
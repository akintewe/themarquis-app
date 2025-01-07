import 'package:marquis_v2/games/checkers/core/models/cordinates.dart';
import 'package:marquis_v2/games/checkers/core/models/pieces.dart';
import 'package:marquis_v2/games/checkers/core/models/sessions.dart';

class GameState {
  final BigInt? sessionId;
  final List<Piece> pieces;
  final bool isLoading;
  final String? error;
  final Piece? selectedPiece;
  final Session? currentSession;
  final List<Coordinates> validMoves;

  const GameState({
    this.sessionId,
    this.pieces = const [],
    this.isLoading = false,
    this.error,
    this.selectedPiece,
    this.currentSession,
    this.validMoves = const [],
  });

  GameState copyWith({
    BigInt? sessionId,
    List<Piece>? pieces,
    bool? isLoading,
    String? error,
    Piece? selectedPiece,
    Session? currentSession,
    List<Coordinates>? validMoves,
  }) => GameState(
    sessionId: sessionId ?? this.sessionId,
    pieces: pieces ?? this.pieces,
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
    selectedPiece: selectedPiece ?? this.selectedPiece,
    currentSession: currentSession ?? this.currentSession,
    validMoves: validMoves ?? this.validMoves,
  );

  bool isValidMove(Coordinates coordinates) =>
    validMoves.any((move) => move == coordinates);
}
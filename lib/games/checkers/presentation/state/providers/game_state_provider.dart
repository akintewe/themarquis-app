import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/games/checkers/core/models/cordinates.dart';
import 'package:marquis_v2/games/checkers/core/models/game_state_model.dart';
import 'package:marquis_v2/games/checkers/core/models/pieces.dart';
import 'package:marquis_v2/games/checkers/presentation/state/providers/repository_provider.dart';

final gameStateProvider =
    StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier(ref);
});

class GameStateNotifier extends StateNotifier<GameState> {
  final Ref ref;

  GameStateNotifier(this.ref) : super(const GameState());

  Future<void> createLobby() async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(gameRepositoryProvider);
      final sessionId = await repository.createLobby();
      final session = await repository.getSession(sessionId);
      final pieces = await repository.getBoardState(sessionId);

      state = state.copyWith(
        sessionId: sessionId,
        currentSession: session,
        pieces: pieces,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> joinLobby(BigInt sessionId) async {
    state = state.copyWith(isLoading: true);
    try {
      final repository = ref.read(gameRepositoryProvider);
      await repository.joinLobby(sessionId);
      final session = await repository.getSession(sessionId);
      final pieces = await repository.getBoardState(sessionId);

      state = state.copyWith(
        sessionId: sessionId,
        currentSession: session,
        pieces: pieces,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> selectPiece(Piece piece) async {
    if (state.sessionId == null) return;

    try {
      final repository = ref.read(gameRepositoryProvider);
      final canChoose = await repository.canChoosePiece(
        piece.position,
        piece.coordinates,
        state.sessionId!,
      );

      if (canChoose) {
        state = state.copyWith(
          selectedPiece: piece,
          validMoves: await getValidMoves(piece),
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> movePiece(Coordinates to) async {
    if (state.selectedPiece == null || !state.isValidMove(to)) return;

    try {
      final repository = ref.read(gameRepositoryProvider);
      await repository.movePiece(state.selectedPiece!, to);
      final pieces = await repository.getBoardState(state.sessionId!);
      final session = await repository.getSession(state.sessionId!);

      state = state.copyWith(
        pieces: pieces,
        currentSession: session,
        selectedPiece: null,
        validMoves: [],
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<List<Coordinates>> getValidMoves(Piece piece) async {
    //TODO:   move validation logic based on game rules
    return [];
  }
}

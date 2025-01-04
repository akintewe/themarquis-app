import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/checkers_contract_service.dart';

final checkersContractProvider = Provider<CheckersContractService>((ref) {
  throw UnimplementedError('Provider must be overridden with the DojoProvider');
});

final checkersGameStateProvider = StateNotifierProvider<CheckersGameStateNotifier, CheckersGameState>((ref) {
  final contractService = ref.watch(checkersContractProvider);
  return CheckersGameStateNotifier(contractService);
});

class CheckersGameState {
  final bool isLoading;
  final String? error;
  final int? sessionId;

  CheckersGameState({
    this.isLoading = false,
    this.error,
    this.sessionId,
  });

  CheckersGameState copyWith({
    bool? isLoading,
    String? error,
    int? sessionId,
  }) {
    return CheckersGameState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class CheckersGameStateNotifier extends StateNotifier<CheckersGameState> {
  final CheckersContractService _contractService;

  CheckersGameStateNotifier(this._contractService) : super(CheckersGameState());

  Future<void> createLobby(dynamic account) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _contractService.createLobby(account);
      // After successful lobby creation, we  may want to get the session ID
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create lobby: $e',
      );
    }
  }
}

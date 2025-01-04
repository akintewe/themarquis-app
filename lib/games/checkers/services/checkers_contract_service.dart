import 'package:js/js.dart';
import '../bindings/checkers_bindings.dart';

@JS('setupWorld')
external dynamic _setupWorld(dynamic provider);

class CheckersContractService {
  final dynamic _provider; // this is the DojoProvider
  dynamic _actions;

  CheckersContractService(this._provider) {
    _actions = _setupWorld(_provider)['actions'];
  }

  Future<void> createLobby(dynamic account) async {
    try {
      await _actions.createLobby(account);
    } catch (e) {
      print('Error creating lobby: $e');
      rethrow;
    }
  }

  Future<void> joinLobby(dynamic account, int sessionId) async {
    try {
      await _actions.joinLobby(account, sessionId);
    } catch (e) {
      print('Error joining lobby: $e');
      rethrow;
    }
  }

  Future<void> spawn(dynamic account, String player, int position, int sessionId) async {
    try {
      await _actions.spawn(account, player, position, sessionId);
    } catch (e) {
      print('Error spawning piece: $e');
      rethrow;
    }
  }

  Future<void> movePiece(dynamic account, Piece currentPiece, Coordinates move) async {
    try {
      await _actions.movePiece(account, currentPiece, move);
    } catch (e) {
      print('Error moving piece: $e');
      rethrow;
    }
  }
} 
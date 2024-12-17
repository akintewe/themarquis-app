import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/checkers/core/components/checkers_board.dart';
import 'package:marquis_v2/games/checkers/core/components/user_stats_component.dart';

enum CheckersPlayState { welcome, waiting, playing, finished }

class CheckersGame extends FlameGame with TapCallbacks, RiverpodGameMixin {
  static const double gameWidth = 450;
  static const double gameHeight = 800;
  
  bool isInit = false;
  CheckersBoard? board;
  late UserStatsComponent userStats;
  int currentPlayer = 0;
  int userIndex = -1;
  bool playerCanMove = false;
  int? winnerIndex;
  bool isErrorMessage = false;

  final ValueNotifier<CheckersPlayState> playStateNotifier = 
      ValueNotifier(CheckersPlayState.welcome);

  CheckersGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: gameWidth,
            height: gameHeight,
          ),
        );

  double get width => size.x;
  double get height => size.y;
  double get unitSize => size.x / 17;
  Vector2 get center => size / 2;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.anchor = Anchor.center;
    
  
    userStats = UserStatsComponent()
      ..position = Vector2(0, 20);
    await add(userStats);
    
    // Calculate board size (80% of the smaller screen dimension to maintain square shape)
    final boardSize = size.x < size.y ? size.x * 0.8 : size.y * 0.8;
    
    // Create and add the board with centered position
    board = CheckersBoard()
      ..size = Vector2.all(boardSize)  // Set the board size explicitly
      ..position = Vector2(
        (size.x - boardSize) / 2.7,  // Center horizontally
        (size.y - boardSize) / 2,  // Center vertically
      );
    
    await add(board!);
  }

  void updateStats({
    required int playerIndex,
    int? lostPieces,
    int? winPieces,
    int? queens,
  }) {
    userStats.updateStats(
      playerIndex: playerIndex,
      lostPieces: lostPieces,
      winPieces: winPieces,
      queens: queens,
    );
  }

  @override
  Color backgroundColor() => Colors.transparent;
} 
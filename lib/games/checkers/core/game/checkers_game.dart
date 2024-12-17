import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/checkers/core/components/checkers_board.dart';
import 'package:marquis_v2/games/checkers/core/components/user_stats_component.dart';
import 'package:marquis_v2/games/checkers/core/utils/constants.dart';

enum CheckersPlayState { welcome, waiting, playing, finished }

class CheckersGame extends FlameGame with TapCallbacks, RiverpodGameMixin {
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
    final minDimension = size.x < size.y ? size.x : size.y;
    final boardSize = minDimension * boardSizePercentage;
    
    // Calculate the horizontal and vertical offsets to center the board
    final horizontalOffset = (size.x - boardSize) * 0.37;
    final verticalOffset = (size.y - boardSize) * 0.5;
    
    // Create and add the board with centered position
    board = CheckersBoard()
      ..size = Vector2.all(boardSize)
      ..position = Vector2(horizontalOffset, verticalOffset);

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
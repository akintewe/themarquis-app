import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:marquis_v2/games/checkers/core/game/checkers_game.dart';

class CheckersGameScreen extends StatelessWidget {
  const CheckersGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        backgroundBuilder: (context) => Image.asset(
          'assets/images/game bg.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        game: CheckersGame(),
        overlayBuilderMap: {
          'gameUI': (context, game) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset('assets/images/Group 1171276336.png'),
              ),
            ),
          ),
        },
        initialActiveOverlays: const ['gameUI'],
      ),
    );
  }
} 
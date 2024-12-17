import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:marquis_v2/games/checkers/core/game/checkers_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:marquis_v2/games/checkers/core/utils/constants.dart';

class CheckersGameScreen extends ConsumerStatefulWidget {
  const CheckersGameScreen({super.key});

  @override
  ConsumerState<CheckersGameScreen> createState() => _CheckersGameScreenState();
}

class _CheckersGameScreenState extends ConsumerState<CheckersGameScreen> {
  final CheckersGame _game = CheckersGame();
  final GlobalKey<RiverpodAwareGameWidgetState<CheckersGame>> _gameWidgetKey =
      GlobalKey<RiverpodAwareGameWidgetState<CheckersGame>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/game bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: AspectRatio(
              aspectRatio: gameWidth / gameHeight,
              child: ValueListenableBuilder<CheckersPlayState>(
                valueListenable: _game.playStateNotifier,
                builder: (context, playState, _) {
                  return RiverpodAwareGameWidget<CheckersGame>(
                    key: _gameWidgetKey,
                    game: _game,
                    overlayBuilderMap: {
                      'gameUI': (context, game) => SafeArea(
                        child: Transform.translate(
                          offset: const Offset(0, topBarOffset),
                          child: Padding(
                            padding: const EdgeInsets.all(uiPadding),
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset('assets/images/Group 1171276336.png'),
                            ),
                          ),
                        ),
                      ),
                    },
                    initialActiveOverlays: const ['gameUI'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
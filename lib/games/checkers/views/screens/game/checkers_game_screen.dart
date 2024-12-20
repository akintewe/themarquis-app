import 'package:flutter/material.dart';
import 'package:marquis_v2/games/checkers/core/game/checkers_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:marquis_v2/games/checkers/core/utils/constants.dart';

import '../../dialogs/game_outcome_dialog.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.shortestSide >= 600;
    
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
            child: Padding(
              padding: isTablet 
                  ? EdgeInsets.symmetric(horizontal: screenSize.width * 0.05)
                  : EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 80.0 : 20.0),
                      child: AspectRatio(
                        aspectRatio: isTablet ? 0.75 : (gameWidth / gameHeight),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: gameWidth ,
                            height: gameHeight ,
                            child: ValueListenableBuilder<CheckersPlayState>(
                              valueListenable: _game.playStateNotifier,
                              builder: (context, playState, _) {
                                return RiverpodAwareGameWidget<CheckersGame>(
                                  key: _gameWidgetKey,
                                  game: _game,
                                  overlayBuilderMap: {
                                    'gameUI': (context, game) => SafeArea(
                                      child: Transform.translate(
                                        offset: Offset(isTablet ? -40 : 0, isTablet ? topBarOffset * 0.1 : topBarOffset),
                                        child: Padding(
                                          padding: EdgeInsets.all(isTablet ? uiPadding * 1.2 : uiPadding * 0.3),
                                          child: GestureDetector(
                                            onTap: () => showDialog(
                                                context: context,
                                                builder: (BuildContext context){
                                                  return GameOutcomeDialog(
                                                    didUserWin: false,
                                                  );
                                                }
                                            ),
                                            child: SizedBox(
                                                width: isTablet ? 60 : 60,
                                                height: isTablet ? 60 : 60,
                                              child: Image.asset(
                                                'assets/images/Group 1171276336.png',

                                                fit: BoxFit.cover,
                                              ),
                                            ),
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
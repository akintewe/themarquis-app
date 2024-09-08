import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/config.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/widgets/overlay_screen.dart';
import 'package:marquis_v2/screens/waiting_room_screen.dart';

void main() {
  runApp(const LudoGameApp());
}

class LudoGameApp extends StatefulWidget {
  // Modify this line
  const LudoGameApp({super.key});

  @override // Add from here...
  State<LudoGameApp> createState() => _LudoGameAppState();
}

class _LudoGameAppState extends State<LudoGameApp> {
  late final LudoGame game;

  @override
  void initState() {
    super.initState();
    game = LudoGame();
  } // To here.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ludo"),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0f1118),
              Color(0xff1f2228),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                // Modify from here...
                children: [
                  // ScoreCard(score: game.score),
                  Expanded(
                    child: FittedBox(
                      child: SizedBox(
                        width: gameWidth,
                        height: gameHeight,
                        child: GameWidget(
                          game: game,
                          overlayBuilderMap: {
                            // PlayState.welcome.name: (context, game) =>
                            //     const OverlayScreen(
                            //       title: 'Waiting Room',
                            //       subtitle: 'Waiting for players...',
                            //     ),
                            PlayState.welcome.name: (context, game) =>
                                const WaitingRoomScreen(),
                            PlayState.gameOver.name: (context, game) =>
                                const OverlayScreen(
                                  title: 'G A M E   O V E R',
                                  subtitle: 'Tap to Play Again',
                                ),
                            PlayState.won.name: (context, game) =>
                                const OverlayScreen(
                                  title: 'Y O U   W O N ! ! !',
                                  subtitle: 'Tap to Play Again',
                                ),
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ), // To here.
            ),
          ),
        ),
      ),
    );
  }
}

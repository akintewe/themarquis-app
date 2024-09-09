import 'package:flutter/material.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class JoinSessionScreen extends StatelessWidget {
  JoinSessionScreen({super.key, required this.game});
  LudoGame game;

  @override
  Widget build(BuildContext context) {
    //27 30 34
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 30, 34, 1),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'JOIN A SESSION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                game.playState = PlayState.waiting;
              },
              child: Text(
                "Join",
                style: TextStyle(
                  fontSize: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

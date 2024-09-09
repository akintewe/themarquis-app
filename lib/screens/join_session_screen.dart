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
              'OPEN SESSION',
              style: TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            roomCard(
              roomName: "ROOM P8U7",
              noOfPlayers: 3,
            ),
            roomCard(
              roomName: "ROOM QW9K",
              noOfPlayers: 1,
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

  Widget roomCard({
    required String roomName,
    required int noOfPlayers,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roomName,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              Text(
                "${noOfPlayers}/4 Players",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //four avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              //join button
              TextButton(
                onPressed: () {},
                child: Text(
                  "JOIN",
                  style: TextStyle(
                    fontSize: 38,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

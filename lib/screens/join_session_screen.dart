import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';

class JoinSessionScreen extends StatelessWidget {
  JoinSessionScreen({super.key, required this.game});
  final LudoGame game;
  final _roomIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //27 30 34
    return Scaffold(
      backgroundColor: const Color.fromRGBO(27, 30, 34, 1),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                openSessionDialog(ctx: context);
              },
              child: Text(
                "Open Session",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                joinRoomDialog(ctx: context);
              },
              child: Text(
                "Join Room",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                createRoomDialog(ctx: context);
              },
              child: Text(
                "Create Room",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future openSessionDialog({required BuildContext ctx}) {
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 0, 236, 255), // Cyan border color
                width: 1, // Border thickness
              ),
              borderRadius: BorderRadius.circular(
                  12), // Ensure the border follows the shape of the dialog
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.70,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              'OPEN SESSION',
                              style: TextStyle(
                                color: Color.fromARGB(
                                    255, 0, 236, 255), // Cyan border color
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.60,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            openSessionRoomCard(
                              roomName: "ROOM P8U7",
                              noOfPlayers: 3,
                            ),
                            openSessionRoomCard(
                              roomName: "ROOM QW9K",
                              noOfPlayers: 1,
                            ),
                            openSessionRoomCard(
                              roomName: "ROOM CMB9",
                              noOfPlayers: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future joinRoomDialog({required BuildContext ctx}) {
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 0, 236, 255), // Cyan border color
                width: 1, // Border thickness
              ),
              borderRadius: BorderRadius.circular(
                  12), // Ensure the border follows the shape of the dialog
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.50 < 280
                  ? 280
                  : MediaQuery.of(context).size.height * 0.50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              'JOIN ROOM',
                              style: TextStyle(
                                color: Color.fromARGB(
                                    255, 0, 236, 255), // Cyan border color
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          label: const Text("Room ID"),
                          // errorText: _emailError,
                        ),
                        controller: _roomIdController,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        game.playState = PlayState.waiting;
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 236, 255),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 42.0,
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future createRoomDialog({required BuildContext ctx}) {
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 0, 236, 255), // Cyan border color
                width: 1, // Border thickness
              ),
              borderRadius: BorderRadius.circular(
                  12), // Ensure the border follows the shape of the dialog
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.50 < 450
                  ? 450
                  : MediaQuery.of(context).size.height * 0.50,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              'CREATE ROOM',
                              style: TextStyle(
                                color: Color.fromARGB(
                                    255, 0, 236, 255), // Cyan border color
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //       label: const Text("Room ID"),
                    //       // errorText: _emailError,
                    //     ),
                    //     controller: _roomIdController,
                    //   ),
                    // ),
                    TextButton(
                      onPressed: () {
                        game.playState = PlayState.waiting;
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 236, 255),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 42.0,
                        ),
                        child: const Text(
                          "Create",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget openSessionRoomCard({
    required String roomName,
    required int noOfPlayers,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                roomName,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                "$noOfPlayers/4 Players",
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //four avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < noOfPlayers; i++)
                    playerAvatarCard(
                      index: i,
                      size: 37,
                    ),
                  for (int i = 0; i < 4 - noOfPlayers; i++)
                    playerEmptyCard(
                      size: 37,
                    ),
                ],
              ),
              //join button
              TextButton(
                onPressed: () {
                  game.playState = PlayState.waiting;
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets
                      .zero, // Remove the default padding from TextButton
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 236, 255), // Background color
                    borderRadius: BorderRadius.circular(8), // Rounded edges
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 30.0,
                  ), // Padding inside the button
                  child: const Text(
                    "JOIN",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black, // Text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget playerAvatarCard({
    required int index,
    required double size,
  }) {
    const playerColors = [
      // Add this const
      Color(0xffd04c2f),
      Color(0xff2fa9d0),
      Color(0xffb0d02f),
      Color(0xff2fd06f),
    ];

    return Padding(
      padding: const EdgeInsets.only(
        right: 8.0,
      ),
      child: Container(
        width: size, // Width of the displayed sprite
        height: size, // Height of the displayed sprite
        decoration: BoxDecoration(
          color: playerColors[index], // Background color
          borderRadius:
              BorderRadius.circular(size / 8), // Rounded corners with radius 24
        ),
        child: FittedBox(
          fit: BoxFit.fill,
          child: ClipRect(
            child: Align(
              alignment: index == 1
                  ? Alignment.topLeft
                  : index == 2
                      ? Alignment.topRight
                      : index == 3
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight,
              // widthFactor: 2160 / 4324,
              // heightFactor: 2160 / 4324,
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Image.asset(
                'assets/images/avatar_spritesheet.png', // Path to your spritesheet
                width: 4324, // Full width of the sprite sheet
                height: 4324, // Full height of the sprite sheet
                fit: BoxFit.none, // Ensure no scaling occurs
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget playerEmptyCard({
    required double size,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 8.0,
      ),
      child: Container(
        width: size, // Width of the displayed sprite
        height: size, // Height of the displayed sprite
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 8),
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Text(
            "?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

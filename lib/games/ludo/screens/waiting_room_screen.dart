import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/models/ludo_session.dart';

class WaitingRoomScreen extends ConsumerStatefulWidget {
  const WaitingRoomScreen({super.key, required this.game});
  final LudoGame game;

  @override
  ConsumerState<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends ConsumerState<WaitingRoomScreen> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(ludoSessionProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: session == null
          ? const Center(child: Text('No Data'))
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top section with title and room ID
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        'WAITING ROOM',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Room ID',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 45,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            session.id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 35,
                          ),
                          const Icon(
                            Icons.copy,
                            size: 45,
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        playerAvatarCard(
                          index: 0,
                          size: 350,
                          isSelf: true,
                          player: session.sessionUserStatus[0],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'VS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 90,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            for (int i = 1;
                                i < session.sessionUserStatus.length;
                                i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: playerAvatarCard(
                                  index: i,
                                  size: 210,
                                  isSelf: false,
                                  player: session.sessionUserStatus[i],
                                ),
                              ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                // Invite Button
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.cyan, // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                    child: Text(
                      'Invite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // Bottom Timer Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 70,
                        ),
                        Text(
                          '00:30:16',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                          ),
                        ),
                        Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                          size: 70,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget playerAvatarCard({
    required int index,
    required double size,
    required bool isSelf,
    required LudoSessionUserStatus player,
  }) {
    const playerColors = [
      // Add this const
      Color(0xffd04c2f),
      Color(0xff2fa9d0),
      Color(0xffb0d02f),
      Color(0xff2fd06f),
    ];
    return Column(
      children: [
        Container(
          width: size, // Width of the displayed sprite
          height: size, // Height of the displayed sprite
          decoration: BoxDecoration(
            color: playerColors[index], // Background color
            borderRadius: BorderRadius.circular(
                size / 8), // Rounded corners with radius 24
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
                child: player.status == "PENDING"
                    ? null
                    : Image.asset(
                        'assets/images/avatar_spritesheet.png', // Path to your spritesheet
                        width: 4324, // Full width of the sprite sheet
                        height: 4324, // Full height of the sprite sheet
                        fit: BoxFit.none, // Ensure no scaling occurs
                      ),
              ),
            ),
          ),
        ),
        Text(
          player.email,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSelf ? 48 : 24,
          ),
        ),
      ],
    );
  }
}

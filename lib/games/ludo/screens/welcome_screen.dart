import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/providers/user.dart';

class LudoWelcomeScreen extends ConsumerStatefulWidget {
  const LudoWelcomeScreen({super.key, required this.game});
  final LudoGame game;

  @override
  ConsumerState<LudoWelcomeScreen> createState() => _LudoWelcomeScreenState();
}

class _LudoWelcomeScreenState extends ConsumerState<LudoWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff0f1118),
      body: Transform.scale(
        scale: widget.game.height / deviceSize.height,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: deviceSize.height * widget.game.width / widget.game.height,
          height: deviceSize.height,
          child: Center(
            child: Column(
              children: [
                Container(
                  width: deviceSize.height *
                      widget.game.width /
                      widget.game.height,
                  height: deviceSize.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/images/banner.png'),
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.darken,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 128,
                        ),
                        Text(
                          'LUDO',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.cyan,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'MENU',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                Expanded(child: _buildMenuOptions()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMenuButton(
            icon: Icons.add,
            text: 'Create Game',
            onTap: () {
              createRoomDialog(ctx: context);
            }),
        const SizedBox(height: 36),
        _buildMenuButton(
            icon: Icons.group,
            text: 'Join Game',
            onTap: () {
              joinRoomDialog(ctx: context);
            }),
        const SizedBox(height: 36),
        _buildMenuButton(
            icon: Icons.casino,
            text: 'Open Sessions',
            onTap: () {
              openSessionDialog(ctx: context);
            }),
      ],
    );
  }

  Widget _buildMenuButton(
      {required IconData icon,
      required String text,
      required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none, // Allow children to be drawn outside the stack
        children: [
          Card(
            child: Container(
              width: 320,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 96), // Space for the overlapping icon
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -5, // Adjust this value to control how much it extends out
            top: -7, // Adjust this value to center vertically
            child: ClipOval(
              child: Container(
                width: 64,
                height: 64,
                color: Colors.grey.withOpacity(0.3),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
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
                color:
                    const Color.fromARGB(255, 0, 236, 255), // Cyan border color
                width: 1, // Border thickness
              ),
              borderRadius: BorderRadius.circular(
                  12), // Ensure the border follows the shape of the dialog
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              height: MediaQuery.of(context).size.height * 0.70,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        const Expanded(
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
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
        return JoinRoomDialog(game: widget.game);
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
                color:
                    const Color.fromARGB(255, 0, 236, 255), // Cyan border color
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        const Expanded(
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
                              icon: const Icon(
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
                        widget.game.playState = PlayState.waiting;
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 0, 236, 255),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
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
                  widget.game.playState = PlayState.waiting;
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets
                      .zero, // Remove the default padding from TextButton
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 0, 236, 255), // Background color
                    borderRadius: BorderRadius.circular(8), // Rounded edges
                  ),
                  padding: const EdgeInsets.symmetric(
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

class JoinRoomDialog extends ConsumerStatefulWidget {
  const JoinRoomDialog({super.key, required this.game});

  final LudoGame game;

  @override
  ConsumerState<JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends ConsumerState<JoinRoomDialog> {
  double _sliderValue = 0;
  int? _tokenBalance;
  String _selectedTokenAddress = '';
  List<Map<String, String>>? _tokens;
  final _roomIdController = TextEditingController();
  final _tokenAmountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: FutureBuilder(
          future: _tokens == null
              ? () async {
                  _tokens = await ref
                      .read(userProvider.notifier)
                      .getSupportedTokens();
                }()
              : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(
                      255, 0, 236, 255), // Cyan border color
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          const Expanded(
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
                                icon: const Icon(
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
                          decoration: const InputDecoration(
                            label: Text("Room ID"),
                            // errorText: _emailError,
                          ),
                          controller: _roomIdController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Token',
                                ),
                                items:
                                    _tokens!.map((Map<String, String> value) {
                                  return DropdownMenuItem<String>(
                                    value: value['tokenAddress']!,
                                    child: Text(value['tokenName']!),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedTokenAddress = newValue!;
                                    _tokenBalance = null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Token Amount',
                                ),
                                controller: _tokenAmountController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$')),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    if (newValue.text.isEmpty) {
                                      return newValue;
                                    }
                                    double? value =
                                        double.tryParse(newValue.text);
                                    if (value != null &&
                                        _tokenBalance != null &&
                                        value <= _tokenBalance! / 1e18) {
                                      return newValue;
                                    }
                                    return oldValue;
                                  }),
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _sliderValue = double.parse(value) * 1e18;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedTokenAddress != "")
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                            future: _tokenBalance != null
                                ? null
                                : () async {
                                    final res = await ref
                                        .read(userProvider.notifier)
                                        .getTokenBalance(_selectedTokenAddress);
                                    _sliderValue = 0;
                                    _tokenBalance = res;
                                  }(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select amount:',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Slider(
                                    min: 0.0,
                                    max: _tokenBalance!.toDouble(),
                                    divisions: 100,
                                    label: '${_sliderValue.round() / 1e18}',
                                    value: _sliderValue,
                                    onChanged: (double value) {
                                      setState(() {
                                        _sliderValue = value;
                                        _tokenAmountController.text =
                                            (_sliderValue / 1e18).toString();
                                      });
                                    },
                                  ),
                                  Text(
                                    'Max: ${_tokenBalance! / 1e18}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            widget.game.playState = PlayState.waiting;
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 236, 255),
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

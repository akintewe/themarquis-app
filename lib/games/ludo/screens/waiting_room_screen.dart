import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gal/gal.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/models/ludo_session.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Transform.scale(
        scale: widget.game.height / deviceSize.height,
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: deviceSize.height * widget.game.width / widget.game.height,
          height: deviceSize.height,
          child: session == null
              ? const Center(child: Text('No Data'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Top section with title and room ID
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'WAITING ROOM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Room ID',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  session.id,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.copy,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: playerAvatarCard(
                                  index: 0,
                                  size: 80,
                                  isSelf: true,
                                  player: session.sessionUserStatus[0],
                                  color: session.getListOfColors[0]),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'VS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 90,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  for (int i = 1;
                                      i < session.sessionUserStatus.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: playerAvatarCard(
                                          index: i,
                                          size: 80,
                                          isSelf: false,
                                          player: session.sessionUserStatus[i],
                                          color: session.getListOfColors[i]),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    // Invite Button
                    ElevatedButton(
                      onPressed: () async {
                        final imageBytes = await _buildShareImage(session);
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.memory(imageBytes),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton.filled(
                                          onPressed: () {
                                            Share.shareXFiles(
                                                [
                                                  XFile.fromData(imageBytes,
                                                      mimeType: 'image/png')
                                                ],
                                                subject: 'Ludo Invite',
                                                text:
                                                    'I am playing Ludo, please join us!',
                                                fileNameOverrides: [
                                                  'share.png'
                                                ]);
                                          },
                                          icon: const Icon(Icons.share)),
                                      IconButton.filled(
                                          onPressed: () async {
                                            await Gal.putImageBytes(imageBytes);
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Image successfully saved to gallery'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.download)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.cyan, // background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10),
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
                    IconButton(
                      onPressed: session.sessionUserStatus
                                  .where((e) => e.status == "ACTIVE")
                                  .length ==
                              4
                          ? () async {
                              widget.game.playState = PlayState.playing;
                            }
                          : null,
                      disabledColor: Colors.grey,
                      icon: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                                "assets/svg/ludo_elevated_button.svg"),
                          ),
                          const Center(
                            child: Text('Game Start',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<Uint8List> _buildShareImage(LudoSessionData session) async {
    final Widget shareWidget = Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Container(
        color: const Color(0xff0f151a),
        width: 675,
        height: 675,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SvgPicture.asset(
                "assets/svg/themarquis_logo_rect.svg",
                width: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: playerAvatarCard(
                        index: index,
                        size: 108,
                        isSelf: false,
                        player: session.sessionUserStatus[index],
                        color: session.getListOfColors[index],
                      ),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'I am playing Ludo, please join us!',
                style: TextStyle(fontSize: 36),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              color: Colors.cyanAccent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "TRY LUDO NOW",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  QrImageView(
                    data: 'https://themarquis.xyz',
                    size: 80,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
    return await createImageFromWidget(shareWidget,
        logicalSize: const Size(675, 675));
  }

  Future<Uint8List> createImageFromWidget(Widget widget,
      {Duration? wait, Size? logicalSize}) async {
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    final view = PlatformDispatcher.instance.views.first;
    logicalSize ??= view.physicalSize / view.devicePixelRatio;

    final RenderView renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
          alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints(
            maxWidth: logicalSize.width, maxHeight: logicalSize.height),
        devicePixelRatio: 1.0,
      ),
    );

    final PipelineOwner pipelineOwner = PipelineOwner();
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    final RenderObjectToWidgetElement<RenderBox> rootElement =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: widget,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);

    if (wait != null) {
      await Future.delayed(wait);
    }

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final ui.Image image = await repaintBoundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    return Uint8List.view(byteData!.buffer);
  }

  Widget playerAvatarCard({
    required int index,
    required double size,
    required bool isSelf,
    required LudoSessionUserStatus player,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: size, // Width of the displayed sprite
          height: size, // Height of the displayed sprite
          decoration: BoxDecoration(
            color: color, // Background color
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
                child: player.status == "ACTIVE"
                    ? Image.asset(
                        'assets/images/avatar_spritesheet.png', // Path to your spritesheet
                        width: 4324, // Full width of the sprite sheet
                        height: 4324, // Full height of the sprite sheet
                        fit: BoxFit.none, // Ensure no scaling occurs
                      )
                    : null,
              ),
            ),
          ),
        ),
        Text(
          player.email,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSelf ? 18 : 12,
          ),
        ),
      ],
    );
  }
}

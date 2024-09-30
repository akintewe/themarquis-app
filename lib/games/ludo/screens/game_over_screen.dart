import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gal/gal.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class MatchResultsScreen extends ConsumerWidget {
  const MatchResultsScreen({super.key, required this.game});
  final LudoGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = MediaQuery.of(context).size;
    print("Device width: ${deviceSize.width}, game width: ${game.width}");
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Transform.scale(
          scale: game.height / deviceSize.height,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: deviceSize.height * game.width / game.height,
            height: deviceSize.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                _buildTransactionsButton(context, ref),
                Expanded(child: _buildResultsList()),
                _buildShareButton(context),
                _buildBackToMenuButton(ref),
                const SizedBox(
                  height: 48,
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'MATCH RESULTS',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsButton(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Transactions'),
                content: FutureBuilder<List<Map>>(
                  future: () async {
                    return await ref
                        .read(ludoSessionProvider.notifier)
                        .getTransactions();
                  }(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : Column(
                              children: snapshot.data!
                                  .map((e) => Text(e.toString()))
                                  .toList(),
                            ),
                ),
              ),
            );
          },
          icon: const Icon(
            FontAwesomeIcons.rightLeft,
            color: Colors.black,
            size: 12,
          ),
          label: const Text('Transactions',
              style: TextStyle(color: Colors.black, fontSize: 12.0)),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0)),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    final results = List.generate(4, (index) {
      final isWinner = index == game.winnerIndex;
      return {
        'index': index,
        'score': isWinner ? 400 : -100,
        'exp': 400, // Assuming all players get 400 EXP regardless of win/loss
      };
    });

    // Sort the results by score (descending order)
    results.sort((a, b) => b['score']!.compareTo(a['score']!));
    for (int i = 0; i < results.length; i++) {
      results[i]['rank'] = i + 1;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...results.map(
          (result) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                _buildRankIndicator(result['rank'] as int),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    game.playerNames[result['index'] as int],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // const Spacer(),
                Text(
                  '${result['rank'] == 1 ? '+' : ''} ${result['score']}',
                  style: TextStyle(
                      color: result['rank'] == 1 ? Colors.yellow : Colors.red,
                      fontSize: 14),
                ),
                const SizedBox(width: 8),
                Text(
                  '+${result['exp']} EXP',
                  style: const TextStyle(color: Colors.cyan, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankIndicator(int rank) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SvgPicture.asset(
          switch (rank) {
            1 => "assets/svg/ludo_rank_1.svg",
            2 => "assets/svg/ludo_rank_2.svg",
            _ => "assets/svg/ludo_rank_3.svg"
          },
          width: 46,
        ),
        Text(
          '$rank',
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final imageBytes = await _buildShareImage();
        if (!context.mounted) return;
        showDialog(
            context: context,
            builder: (ctx) => Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.memory(imageBytes),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton.filled(
                                onPressed: () {
                                  Share.shareXFiles(
                                      [
                                        XFile.fromData(imageBytes,
                                            mimeType: 'image/png')
                                      ],
                                      subject: 'Ludo Results',
                                      text:
                                          'I am playing Ludo, please join us!',
                                      fileNameOverrides: ['share.png']);
                                },
                                icon: const Icon(Icons.share)),
                            IconButton.filled(
                                onPressed: () async {
                                  await Gal.putImageBytes(imageBytes);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
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
                ));
      },
      icon: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
              child: SvgPicture.asset("assets/svg/ludo_elevated_button.svg")),
          const Center(
            child: Text('Share',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToMenuButton(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: () async {
          await ref.read(userProvider.notifier).getUser();
          game.playState = PlayState.welcome;
        },
        child:
            const Text('Back to Menu', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<Uint8List> _buildShareImage() async {
    final Widget shareWidget = Directionality(
      textDirection: ui.TextDirection.ltr,
      child: SizedBox(
        width: 675,
        height: 675,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    "assets/svg/themarquis_logo_rect.svg",
                    width: 300,
                  ),
                  const Text(
                    "Match Results",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildResultsList(),
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
}

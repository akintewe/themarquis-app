import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
          scale: game.width / deviceSize.width,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: deviceSize.width,
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
                content: FutureBuilder<Map<String, dynamic>>(
                  future: () async {
                    return await ref
                        .read(ludoSessionProvider.notifier)
                        .getTransactions();
                  }(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : Text(
                              snapshot.data.toString(),
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
    final results = [
      {'rank': 1, 'score': 400, 'exp': 400},
      {'rank': 2, 'score': 100, 'exp': 400},
      {'rank': 3, 'score': 100, 'exp': 400},
      {'rank': 4, 'score': 100, 'exp': 400},
    ];
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
                const SizedBox(width: 16),
                const Text('YIXUAN',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                const Spacer(),
                Text(
                  '${result['rank'] == 0 ? '+' : '-'} ${result['score']}',
                  style: TextStyle(
                      color: result['rank'] == 0 ? Colors.yellow : Colors.red,
                      fontSize: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  '+${result['exp']} EXP',
                  style: const TextStyle(color: Colors.cyan, fontSize: 18),
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
          width: 50,
        ),
        Text(
          '$rank',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                                onPressed: () {},
                                icon: const Icon(Icons.share)),
                            IconButton.filled(
                                onPressed: () {},
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
        onPressed: () {
          ref.read(appStateProvider.notifier).selectGame(null);
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

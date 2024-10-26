import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gal/gal.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/games/ludo/models/ludo_session.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchResultsScreen extends ConsumerWidget {
  const MatchResultsScreen(
      {super.key, required this.session, required this.game});
  final LudoSessionData session;
  final LudoGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = session.sessionUserStatus.map((element) {
      final numWinningTokens = element.playerWinningTokens
          .map((e) => e ? 1 : 0)
          .reduce((a, b) => a + b);
      return {
        'index': session.sessionUserStatus.indexOf(element),
        'score': numWinningTokens == 4 ? 400 : -100,
        'numWinningTokens': numWinningTokens,
        'exp': 400,
      };
    }).toList();
    results.sort(
        (a, b) => b['numWinningTokens']!.compareTo(a['numWinningTokens']!));
    for (int i = 0; i < results.length; i++) {
      results[i]['rank'] = i + 1;
    }
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
            child: FutureBuilder<List<Map<String, dynamic>>>(future: () async {
              final supportedTokens =
                  await ref.read(userProvider.notifier).getSupportedTokens();
              supportedTokens.add({
                "tokenAddress":
                    "0x0000000000000000000000000000000000000000000000000000000000000000",
                "tokenName": "No Token",
              });
              return supportedTokens;
            }(), builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        _buildTransactionsButton(context),
                        Expanded(
                            child: _buildResultsList(results, snapshot.data!)),
                        _buildShareButton(context, results, snapshot.data!),
                        _buildBackToMenuButton(ref),
                        const SizedBox(
                          height: 48,
                        )
                      ],
                    );
            }),
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

  Widget _buildTransactionsButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                scrollable: true,
                title: const Text('Transactions'),
                content: FutureBuilder<List<Map>>(
                  future: () async {
                    return await getTransactions(session.id);
                  }(),
                  builder: (context, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? const CircularProgressIndicator()
                      : snapshot.data!.isEmpty
                          ? const Center(
                              child: Text('No transactions available.'))
                          : Column(
                              children: snapshot.data!.map(
                                (tx) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Card(
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Transaction Type and ID
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  tx['transaction_type_name'],
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'ID: ${tx['id']}',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Transaction Hash with copy functionality
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Hash: ${_shortenHash(tx['transaction_hash'])}',
                                                    style: const TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  InkWell(
                                                    child: const Icon(
                                                        Icons.copy,
                                                        size: 12),
                                                    onTap: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: tx[
                                                                  'transaction_hash']));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Hash copied to clipboard')),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Session ID
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Session ID: ${tx['session_id']}',
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ),
                                            // Created and Updated At
                                            Text(
                                              'Created: ${_formatDate(tx['created_at'])}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[700]),
                                            ),
                                            Text(
                                              'Updated: ${_formatDate(tx['updated_at'])}',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[700]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
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

  // Helper method to shorten the transaction hash for display
  String _shortenHash(String hash) {
    if (hash.length <= 20) return hash;
    return '${hash.substring(0, 4)}...${hash.substring(hash.length - 4)}';
  }

  // Helper method to format date strings
  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(date.toLocal());
  }

  Widget _buildResultsList(List<Map<String, dynamic>> results,
      List<Map<String, dynamic>> supportedTokens) {
    // Sort the results by score (descending order)
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
                    session.sessionUserStatus[result['index'] as int].email
                        .split('@')[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // const Spacer(),
                if (session.playToken !=
                    "0x0000000000000000000000000000000000000000000000000000000000000000")
                  Builder(builder: (context) {
                    final playAmount = result['score'] > 0
                        ? (double.parse(session.playAmount) * 4 / 1e18)
                        : (double.parse(session.playAmount) / 1e18);
                    final tokenName = supportedTokens.firstWhere((e) =>
                            e["tokenAddress"] ==
                            session.playToken)["tokenName"] ??
                        "";
                    return Text(
                      '${result['rank'] == 1 ? '+' : '-'} ${playAmount.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')} $tokenName',
                      style: TextStyle(
                          color:
                              result['rank'] == 1 ? Colors.yellow : Colors.red,
                          fontSize: 14),
                    );
                  }),
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

  Widget _buildRankIndicator(int rank, {double width = 46}) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SvgPicture.asset(
          switch (rank) {
            1 => "assets/svg/ludo_rank_1.svg",
            2 => "assets/svg/ludo_rank_2.svg",
            3 => "assets/svg/ludo_rank_3.svg",
            _ => "assets/svg/ludo_rank_4.svg"
          },
          width: width,
        ),
        Text(
          '$rank',
          style: TextStyle(
              color: Colors.white,
              fontSize: width * 12 / 40,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildShareButton(
      BuildContext context,
      List<Map<String, dynamic>> results,
      List<Map<String, dynamic>> supportedTokens) {
    return IconButton(
      onPressed: () async {
        final imageBytes = await _buildShareImage(results, supportedTokens);
        if (!context.mounted) return;
        showDialog(
            context: context,
            barrierColor: Colors.black.withAlpha(220),
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton.filled(
                              onPressed: () async {
                                final tweetText =
                                    'Check out my results!\nRoom Id: ${session.id}';
                                final url =
                                    'https://themarquis.xyz/ludo?roomid=${session.id}';

                                // Use the Twitter app's URL scheme
                                final tweetUrl = Uri.encodeFull(
                                    'twitter://post?message=$tweetText\n$url\ndata:image/png;base64,${base64Encode(imageBytes)}');

                                // Fallback to web URL if the app isn't installed
                                final webTweetUrl = Uri.encodeFull(
                                    'https://x.com/intent/tweet?text=$tweetText&url=$url&via=themarquisxyz&image=data:image/png;base64,${base64Encode(imageBytes)}');

                                if (await canLaunchUrl(Uri.parse(tweetUrl))) {
                                  await launchUrl(Uri.parse(tweetUrl));
                                } else {
                                  await launchUrl(Uri.parse(webTweetUrl));
                                }
                              },
                              icon: const Icon(FontAwesomeIcons.xTwitter),
                            ),
                            // IconButton.filled(
                            //   onPressed: () {
                            //     Share.shareXFiles(
                            //         [
                            //           XFile.fromData(imageBytes,
                            //               mimeType: 'image/png')
                            //         ],
                            //         subject: 'Ludo Results',
                            //         text: 'I am playing Ludo, please join us!',
                            //         fileNameOverrides: ['share.png']);
                            //   },
                            //   icon: const Icon(Icons.share),
                            // ),
                            IconButton.filled(
                              onPressed: () {
                                Share.shareXFiles(
                                    [
                                      XFile.fromData(imageBytes,
                                          mimeType: 'image/png')
                                    ],
                                    subject: 'Ludo Results',
                                    text: 'I am playing Ludo, please join us!',
                                    fileNameOverrides: ['share.png']);
                              },
                              icon: const Icon(Icons.share),
                            ),
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
                              icon: const Icon(Icons.download),
                            ),
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
          // await ref.read(userProvider.notifier).getUser();
          game.playState = PlayState.welcome;
          game.overlays.remove(PlayState.finished.name);

          await ref
              .read(ludoSessionProvider.notifier)
              .clearData(refreshUser: true);
        },
        child:
            const Text('Back to Menu', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<Uint8List> _buildShareImage(List<Map<String, dynamic>> results,
      List<Map<String, dynamic>> supportedTokens) async {
    final Widget shareWidget = Directionality(
      textDirection: ui.TextDirection.ltr,
      child: SizedBox(
        width: 800,
        height: 418,
        child: Stack(
          children: [
            Image.asset("assets/images/game_results_bg.png"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 180),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShareImageItem(results[0], supportedTokens),
                      _buildShareImageItem(results[1], supportedTokens),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildShareImageItem(results[2], supportedTokens),
                      _buildShareImageItem(results[3], supportedTokens),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return await createImageFromWidget(shareWidget,
        logicalSize: const Size(800, 418));
  }

  Widget _buildShareImageItem(
      Map<String, dynamic> result, List<Map<String, dynamic>> supportedTokens) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 64.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildRankIndicator(result['rank'] as int, width: 90),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  session.sessionUserStatus[result['index'] as int].email
                      .split('@')[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (session.playToken !=
                        "0x0000000000000000000000000000000000000000000000000000000000000000")
                      Builder(builder: (context) {
                        final playAmount = result['score'] > 0
                            ? (double.parse(session.playAmount) * 4 / 1e18)
                            : (double.parse(session.playAmount) / 1e18);
                        final tokenName = supportedTokens.firstWhere((e) =>
                                e["tokenAddress"] ==
                                session.playToken)["tokenName"] ??
                            "";
                        return Text(
                          '${result['rank'] == 1 ? '+' : '-'} ${playAmount.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')} $tokenName',
                          style: TextStyle(
                              color: result['rank'] == 1
                                  ? Colors.yellow
                                  : Colors.red,
                              fontSize: 14),
                        );
                      }),
                    const SizedBox(height: 4),
                    Text(
                      '+${result['exp']} EXP',
                      style: const TextStyle(
                        color: Colors.cyan,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/games/ludo/widgets/angled_submit_shape.dart';
import 'package:marquis_v2/games/ludo/widgets/chevron_border.dart';
import 'package:marquis_v2/games/ludo/widgets/divider_shape.dart';
import 'package:marquis_v2/games/ludo/widgets/pin_color_option.dart';
import 'package:marquis_v2/games/ludo/widgets/radio_option.dart';
import 'package:marquis_v2/games/ludo/widgets/stepper_option_card.dart';
import 'package:marquis_v2/games/ludo/widgets/vertical_stepper.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:marquis_v2/widgets/error_dialog.dart';
import 'package:marquis_v2/widgets/user_app_bar.dart';

enum NumberOfPlayers {
  two,
  four;
}

enum GameMode {
  free,
  token;
}

class CreateGameScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CreateGameScreen> createState() => _CreateGameScreenState();

  const CreateGameScreen({super.key});
}

class _CreateGameScreenState extends ConsumerState<CreateGameScreen> {
  int _activeTab = 0;
  NumberOfPlayers? _numberOfPlayers;
  GameMode? _gameMode;
  String? _selectedTokenAddress;
  double? _selectedTokenAmount;
  String? _playerColor;
  final Map<String, String> _supportedTokens = {};

  void _selectNumberOfPlayers(NumberOfPlayers numberOfPlayers) {
    setState(() {
      _numberOfPlayers = numberOfPlayers;
      _activeTab = 1;
    });
  }

  void _selectGameMode(GameMode gameMode) {
    setState(() {
      _gameMode = gameMode;
      _selectedTokenAddress = null;
      _selectedTokenAmount = null;
      _activeTab = gameMode == GameMode.token ? 2 : 3;
    });
  }

  void _selectPinColor(String pinColor) {
    setState(() {
      _playerColor = pinColor;
    });
  }

  void _selectTokenAddress(String tokenAddress) {
    setState(() {
      _selectedTokenAmount = null;
      _selectedTokenAddress = tokenAddress;
    });
  }

  void _selectTokenAmount(double amount) {
    if (amount == 0) {
      _selectedTokenAmount = amount;
      return;
    }
    setState(() {
      _selectedTokenAmount = amount;
    });
  }

  Future<void> _createGame() async {
    final game = ModalRoute.of(context)!.settings.arguments as LudoGame;
    final color = _playerColor!.split("/").last.split(".").first.split("_").first;
    try {
      await ref.read(ludoSessionProvider.notifier).createSession(
            (_selectedTokenAmount ?? 0).toString(),
            color,
            _selectedTokenAddress ?? "0x0000000000000000000000000000000000000000000000000000000000000000",
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      game.playState = PlayState.waiting;
    } catch (e) {
      if (!context.mounted) return;
      showErrorDialog(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const UserAppbar(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double scaledHeight(double height) {
            return (height / 717) * constraints.maxHeight;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 7, top: 17, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('CREATE GAME', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white)),
                    GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: Container(
                        decoration: ShapeDecoration(color: Colors.white, shape: ChevronBorder()),
                        padding: const EdgeInsets.only(top: 1, left: 8, bottom: 1, right: 31),
                        child: const Text('MENU', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: scaledHeight(10),
                decoration: const ShapeDecoration(color: Color(0xFF00ECFF), shape: DividerShape(Color(0xFF00ECFF))),
              ),
              const SizedBox(height: 21),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      child: VerticalStepper(activeTab: _activeTab, numberOfSteps: _gameMode == GameMode.token ? 4 : 3),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StepperOptionCard(
                            isEnabled: _activeTab == 0 || _playerColor != null,
                            cardIndex: 0,
                            activeCardIndex: _activeTab,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: scaledHeight(38)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Number of players', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  SizedBox(height: scaledHeight(12)),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RadioOption(
                                        width: 110,
                                        padding: EdgeInsets.symmetric(vertical: scaledHeight(5)),
                                        value: NumberOfPlayers.two,
                                        globalValue: _numberOfPlayers,
                                        onTap: _selectNumberOfPlayers,
                                        selectedBackgroundColor: const Color(0x1200ECFF),
                                        unSelectedBackgroundColor: Colors.transparent,
                                        borderColor: const Color(0xFF00ECFF),
                                        activeShadow: const BoxShadow(blurStyle: BlurStyle.inner, blurRadius: 21.5, spreadRadius: 1, color: Color(0xFF00ECFF)),
                                        child: const Text('2 Players', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF00ECFF))),
                                      ),
                                      const SizedBox(width: 8),
                                      RadioOption(
                                        width: 110,
                                        padding: EdgeInsets.symmetric(vertical: scaledHeight(5)),
                                        value: NumberOfPlayers.four,
                                        globalValue: _numberOfPlayers,
                                        onTap: _selectNumberOfPlayers,
                                        selectedBackgroundColor: const Color(0x1200ECFF),
                                        unSelectedBackgroundColor: Colors.transparent,
                                        borderColor: const Color(0xFF00ECFF),
                                        activeShadow: const BoxShadow(blurStyle: BlurStyle.inner, blurRadius: 21.5, spreadRadius: 1, color: Color(0xFF00ECFF)),
                                        child: const Text('4 Players', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF00ECFF))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StepperOptionCard(
                            isEnabled: _playerColor != null,
                            cardIndex: 1,
                            activeCardIndex: _activeTab,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 38),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Game Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  SizedBox(height: scaledHeight(12)),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RadioOption(
                                        width: 110,
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        value: GameMode.free,
                                        globalValue: _gameMode,
                                        onTap: _selectGameMode,
                                        selectedBackgroundColor: const Color(0x1200ECFF),
                                        unSelectedBackgroundColor: Colors.transparent,
                                        borderColor: const Color(0xFF00ECFF),
                                        activeShadow: const BoxShadow(blurStyle: BlurStyle.inner, blurRadius: 21.5, spreadRadius: 1, color: Color(0xFF00ECFF)),
                                        child: const Text('Free', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF00ECFF))),
                                      ),
                                      const SizedBox(width: 8),
                                      RadioOption(
                                        width: 110,
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        value: GameMode.token,
                                        globalValue: _gameMode,
                                        onTap: _selectGameMode,
                                        selectedBackgroundColor: const Color(0x1200ECFF),
                                        unSelectedBackgroundColor: Colors.transparent,
                                        borderColor: const Color(0xFF00ECFF),
                                        activeShadow: const BoxShadow(blurStyle: BlurStyle.inner, blurRadius: 21.5, spreadRadius: 1, color: Color(0xFF00ECFF)),
                                        child: const Text('Token', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF00ECFF))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          StepperOptionCard(
                            isEnabled: _gameMode == GameMode.token && _playerColor != null,
                            cardIndex: 2,
                            activeCardIndex: _activeTab,
                            isDisabled: _gameMode != GameMode.token,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                              child: FutureBuilder(
                                future: _supportedTokens.isEmpty ? ref.read(userProvider.notifier).getSupportedTokens() : null,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                                  if (snapshot.hasData) {
                                    _supportedTokens.clear();
                                    for (var item in snapshot.data!) {
                                      _supportedTokens.addAll({item["tokenName"]!: item["tokenAddress"]!});
                                    }
                                  }
                                  if (_supportedTokens.isEmpty) {
                                    return Center(child: TextButton(onPressed: () => setState(() {}), child: const Text('retry')));
                                  }
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Play Amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RadioOption(
                                            value: _supportedTokens["STRK"],
                                            globalValue: _selectedTokenAddress,
                                            onTap: _selectTokenAddress,
                                            selectedBackgroundColor: const Color(0xFF00ECFF),
                                            unSelectedBackgroundColor: Colors.transparent,
                                            borderColor: const Color(0xFF00ECFF),
                                            width: 108,
                                            padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/images/STRK_logo.png'),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'STRK',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: _selectedTokenAddress == "" ? Colors.black : const Color(0xFF00ECFF)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          RadioOption(
                                            value: _supportedTokens["ETH"],
                                            globalValue: _selectedTokenAddress,
                                            onTap: _selectTokenAddress,
                                            selectedBackgroundColor: const Color(0xFF00ECFF),
                                            unSelectedBackgroundColor: Colors.transparent,
                                            borderColor: const Color(0xFF00ECFF),
                                            width: 108,
                                            padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/images/eth_icon.png'),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'ETH',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: _selectedTokenAddress == "" ? Colors.black : const Color(0xFF00ECFF)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RadioOption(
                                            value: _supportedTokens["LORDS"],
                                            globalValue: _selectedTokenAddress,
                                            onTap: _selectTokenAddress,
                                            selectedBackgroundColor: const Color(0xFF00ECFF),
                                            unSelectedBackgroundColor: Colors.transparent,
                                            borderColor: const Color(0xFF00ECFF),
                                            width: 108,
                                            padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/images/lords_icon.png'),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'LORDS',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: _selectedTokenAddress == "" ? Colors.black : const Color(0xFF00ECFF)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          RadioOption(
                                            value: _supportedTokens["BROTHER"],
                                            globalValue: _selectedTokenAddress,
                                            onTap: _selectTokenAddress,
                                            selectedBackgroundColor: const Color(0xFF00ECFF),
                                            unSelectedBackgroundColor: Colors.transparent,
                                            borderColor: const Color(0xFF00ECFF),
                                            width: 108,
                                            padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Image.asset('assets/images/brother_icon.png'),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'BROTHER',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: _selectedTokenAddress == "" ? Colors.black : const Color(0xFF00ECFF)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      FutureBuilder(
                                        future: _selectedTokenAddress == null || (_selectedTokenAmount ?? 0) > 0
                                            ? null
                                            : ref.read(userProvider.notifier).getTokenBalance(_selectedTokenAddress!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Slider(
                                                min: 0,
                                                divisions: 100,
                                                activeColor: Colors.white,
                                                secondaryActiveColor: Colors.cyan,
                                                allowedInteraction: SliderInteraction.slideThumb,
                                                max: snapshot.data?.toDouble() ?? 0,
                                                value: _selectedTokenAmount ?? 0,
                                                onChanged: _selectTokenAmount,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text('Min', style: TextStyle(fontSize: 10, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w400)),
                                                      const SizedBox(width: 13),
                                                      SizedBox(
                                                        width: 60,
                                                        child: Text(
                                                          '$_selectedTokenAmount',
                                                          style: const TextStyle(fontSize: 10, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w400),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const Text('Max', style: TextStyle(fontSize: 10, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w400)),
                                                      const SizedBox(width: 13),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          const Text('Balance',
                                                              style: TextStyle(fontSize: 10, color: Color(0x66FFFFFF), fontWeight: FontWeight.w400)),
                                                          SizedBox(
                                                            width: 60,
                                                            child: Text(
                                                              '${snapshot.data?.toDouble() ?? 0}',
                                                              style: const TextStyle(fontSize: 10, color: Color(0xFFFFFFFF), fontWeight: FontWeight.w400),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          StepperOptionCard(
                            isEnabled: _gameMode == GameMode.free || ((_selectedTokenAddress?.isNotEmpty ?? false) && ((_selectedTokenAmount ?? 0) > 0)),
                            cardIndex: 3,
                            activeCardIndex: _activeTab,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: scaledHeight(28)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Pin Color', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PinColorOption(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xFF005C30), Color(0x730C3823), Color(0xFF005C30)],
                                        ),
                                        svgPath: 'assets/svg/chess-and-bg/green_chess.svg',
                                        selectedPinColor: _playerColor,
                                        onTap: _selectPinColor,
                                      ),
                                      SizedBox(width: scaledHeight(12)),
                                      PinColorOption(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xC700CEDB), Color(0x73145559), Color(0x9E00CEDB)],
                                        ),
                                        svgPath: 'assets/svg/chess-and-bg/blue_chess.svg',
                                        selectedPinColor: _playerColor,
                                        onTap: _selectPinColor,
                                      ),
                                      const SizedBox(width: 8),
                                      PinColorOption(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xC7DB0000), Color(0x73591414), Color(0x9EDB0000)],
                                        ),
                                        svgPath: 'assets/svg/chess-and-bg/red_chess.svg',
                                        selectedPinColor: _playerColor,
                                        onTap: _selectPinColor,
                                      ),
                                      const SizedBox(width: 8),
                                      PinColorOption(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Color(0xC7DBD200), Color(0x73595214), Color(0x9EDBD200)],
                                        ),
                                        svgPath: 'assets/svg/chess-and-bg/yellow_chess.svg',
                                        selectedPinColor: _playerColor,
                                        onTap: _selectPinColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _createGame,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 29),
                      decoration: ShapeDecoration(
                        color: _playerColor == null ? const Color(0xFF32363A) : const Color(0xFF00ECFF),
                        shape: AngledSubmitShape(_playerColor == null ? const Color(0xFF939393) : const Color(0xFF000000)),
                      ),
                      width: double.infinity,
                      height: scaledHeight(52),
                      alignment: Alignment.center,
                      child: Visibility(
                        replacement: const Center(child: CircularProgressIndicator()),
                        child: Text('CREATE GAME', style: TextStyle(color: _playerColor == null ? const Color(0xFF939393) : const Color(0xFF000000))),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

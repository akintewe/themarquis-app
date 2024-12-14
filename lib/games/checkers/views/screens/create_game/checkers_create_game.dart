import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquis_v2/games/checkers/core/utils/checkers_enum.dart';
import 'package:marquis_v2/games/checkers/views/widgets/checkers_radio.dart';
import 'package:marquis_v2/games/checkers/views/widgets/checkers_stepper.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/games/ludo/ludo_session.dart';
import 'package:marquis_v2/games/ludo/widgets/chevron_border.dart';
import 'package:marquis_v2/games/ludo/widgets/divider_shape.dart';
import 'package:marquis_v2/games/ludo/widgets/radio_option.dart';
import 'package:marquis_v2/widgets/balance_appbar.dart';
import 'package:marquis_v2/widgets/error_dialog.dart';

class CheckersCreateGame extends ConsumerStatefulWidget {
  @override
  ConsumerState<CheckersCreateGame> createState() => _CheckersCreateGameState();

  const CheckersCreateGame({super.key});
}

class _CheckersCreateGameState extends ConsumerState<CheckersCreateGame> {
  int _activeTab = 0;
  double _selectedTokenBalance = 0;
  NumberOfPlayers? _numberOfPlayers;
  GameMode? _gameMode;
  String? _selectedTokenAddress;

  double? _selectedTokenAmount;
  String? _playerColor;
  bool _isLoading = false;
  final Map<String, String> _supportedTokens = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const BalanceAppBar(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double scaledHeight(double height) {
            return (height / 749) * constraints.maxHeight;
          }

          return Column(
            children: [
              _topBar(context, scaledHeight),
              SizedBox(height: _activeTab == _numberOfTabs ? 31 : 21),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 32,
                      child: CheckersStepper(
                        activeTab: _activeTab,
                        numberOfSteps: _numberOfTabs,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Container(
                        height: scaledHeight(462),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF21262B),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_activeTab == 0) _selectGame(scaledHeight),
                            if (_activeTab == 1) _selectCharacter(scaledHeight),
                            if (_activeTab == 2 && _gameMode == GameMode.token)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: _selectPlayAmount(),
                              ),
                          ],
                        ),
                      ),
                    ),
                    // ],
                    if (_activeTab == _numberOfTabs && _playerColor != null)
                      SizedBox(
                        width: constraints.maxWidth - 24,
                        height: scaledHeight(462),
                        child: Column(
                          children: [
                            const SizedBox(height: 4),
                            if (_selectedTokenAddress != null) ...[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF21262B),
                                      borderRadius: BorderRadius.circular(8)),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Play Amount'),
                                      const SizedBox(height: 12),
                                      RadioOption(
                                        value: _selectedTokenAddress,
                                        globalValue: _selectedTokenAddress,
                                        onTap: (_) {},
                                        selectedBackgroundColor:
                                            const Color(0x1200ECFF),
                                        unSelectedBackgroundColor:
                                            Colors.transparent,
                                        borderColor: const Color(0xFF00ECFF),
                                        width: 130,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/${_supportedTokens['ETH'] == _selectedTokenAddress ? 'eth_icon' : _supportedTokens['STRK'] == _selectedTokenAddress ? 'STRK_logo' : _supportedTokens['LORDS'] == _selectedTokenAddress ? 'lords_icon' : 'brother_logo'}.png",
                                            ),
                                            const Flexible(
                                                child: SizedBox(width: 10)),
                                            Text(
                                              (_selectedTokenAmount! / 1e18)
                                                  .toStringAsFixed(7),
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Color(0xFF00ECFF)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: scaledHeight(20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    if (_activeTab == 3) ...[
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(
                              double.infinity,
                              scaledHeight(43),
                            ),
                            side: const BorderSide(
                              color: Color(0xFFF3B46E),
                            ),
                            foregroundColor: const Color(0xFFF3B46E),
                            textStyle: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: _switchToPreviousTab,
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(
                            double.infinity,
                            scaledHeight(43),
                          ),
                          disabledBackgroundColor: const Color(0xFF32363A),
                          backgroundColor: const Color(0xFFF3B46E),
                          disabledForegroundColor: const Color(0xFF939393),
                          foregroundColor: const Color(0xFF000000),
                          textStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: _activeTab == _numberOfTabs
                            ? _createGame
                            : _isNextEnabled
                                ? _switchToNextTab
                                : null,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                _activeTab == _numberOfTabs &&
                                        _playerColor != null
                                    ? 'Create Game'
                                    : 'Next',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _selectPlayAmount() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Select Play Amount',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckersRadio(
              value: _supportedTokens["STRK"],
              globalValue: _selectedTokenAddress,
              onTap: _selectTokenAddress,
              selectedBackgroundColor: const Color(0x1200ECFF),
              unSelectedBackgroundColor: Colors.transparent,
              borderColor: const Color(0xFFF3B46E),
              width: 130,
              padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
              child: Row(
                children: [
                  Image.asset('assets/images/STRK_logo.png'),
                  const SizedBox(width: 4),
                  Text(
                    'STRK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFF3B46E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            CheckersRadio(
              value: _supportedTokens["ETH"],
              globalValue: _selectedTokenAddress,
              onTap: _selectTokenAddress,
              selectedBackgroundColor: const Color(0x1200ECFF),
              unSelectedBackgroundColor: Colors.transparent,
              borderColor: const Color(0xFFF3B46E),
              width: 130,
              padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
              child: Row(
                children: [
                  Image.asset('assets/images/eth_icon.png'),
                  const SizedBox(width: 4),
                  Text(
                    'ETH',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFF3B46E),
                    ),
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
            CheckersRadio(
              value: _supportedTokens["LORDS"],
              globalValue: _selectedTokenAddress,
              onTap: _selectTokenAddress,
              selectedBackgroundColor: const Color(0x1200ECFF),
              unSelectedBackgroundColor: Colors.transparent,
              borderColor: const Color(0xFFF3B46E),
              width: 130,
              padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
              child: Row(
                children: [
                  Image.asset('assets/images/lords_icon.png'),
                  const SizedBox(width: 4),
                  Text(
                    'LORDS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFF3B46E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            CheckersRadio(
              value: _supportedTokens["BROTHER"],
              globalValue: _selectedTokenAddress,
              onTap: _selectTokenAddress,
              selectedBackgroundColor: const Color(0x1200ECFF),
              unSelectedBackgroundColor: Colors.transparent,
              borderColor: const Color(0xFFF3B46E),
              width: 130,
              padding: const EdgeInsets.only(left: 14, top: 4, bottom: 4),
              child: Row(
                children: [
                  Image.asset('assets/images/brother_icon.png'),
                  const SizedBox(width: 4),
                  Text(
                    'BROTHER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFF3B46E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              min: 0,
              divisions: 100,
              activeColor: Colors.white,
              label: ((_selectedTokenAmount ?? 0) / 1e18).toStringAsFixed(7),
              secondaryActiveColor: Colors.cyan,
              allowedInteraction: SliderInteraction.slideThumb,
              max: _selectedTokenBalance.toDouble(),
              value: _selectedTokenAmount ?? 0,
              onChanged: _selectTokenAmount,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Min',
                      style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 13),
                    SizedBox(
                      width: 80,
                      child: Text(
                        ((_selectedTokenAmount ?? 0) / 1e18).toStringAsFixed(7),
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400,
                        ),
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
                    Text(
                      'Max',
                      style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Balance\t\t',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          (_selectedTokenBalance.toDouble() / 1e18)
                              .toStringAsFixed(7),
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            color: const Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _selectGame(double Function(double height) scaledHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Select Game Mode',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: scaledHeight(12),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckersRadio(
              width: 110,
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
              value: GameMode.free,
              globalValue: _gameMode,
              onTap: _selectGameMode,
              selectedBackgroundColor: const Color(0x1200ECFF),
              unSelectedBackgroundColor: Colors.transparent,
              borderColor: const Color(0xFFF3B46E),
              child: const Text(
                'Free',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFF3B46E)),
              ),
            ),
            const SizedBox(width: 8),
            CheckersRadio(
              width: 110,
              padding: const EdgeInsets.symmetric(vertical: 5),
              value: GameMode.token,
              globalValue: _gameMode,
              onTap: _selectGameMode,
              selectedBackgroundColor: const Color(0x1200ECFF),
              unSelectedBackgroundColor: Colors.transparent,
              borderColor: const Color(0xFFF3B46E),
              child: const Text(
                'Token',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFF3B46E)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _selectCharacter(double Function(double height) scaledHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Choose a character',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: scaledHeight(12),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3B46E),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/jason.png',
                  width: 91,
                  height: 91,
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3B46E),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/desire.png',
                  width: 91,
                  height: 91,
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3B46E),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/esther.png',
                  width: 91,
                  height: 91,
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF3B46E),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/olivia.png',
                  width: 91,
                  height: 91,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _topBar(
      BuildContext context, double Function(double height) scaledHeight) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            right: 7,
            top: 17,
            bottom: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'CREATE GAME',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: ChevronBorder(),
                  ),
                  padding: const EdgeInsets.only(
                    top: 1,
                    left: 8,
                    bottom: 1,
                    right: 31,
                  ),
                  child: const Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: scaledHeight(10),
          decoration: const ShapeDecoration(
            color: Color(0xFFF3B46E),
            shape: DividerShape(
              Color(0xFFF3B46E),
            ),
          ),
        ),
      ],
    );
  }

  void _selectNumberOfPlayers(NumberOfPlayers numberOfPlayers) {
    setState(() {
      _numberOfPlayers = numberOfPlayers;
    });
  }

  void _selectGameMode(GameMode gameMode) {
    setState(() {
      _gameMode = gameMode;
      _selectedTokenAddress = null;
      _selectedTokenAmount = null;
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
      _selectedTokenBalance = 0;
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

  void _switchToNextTab() {
    setState(() {
      _activeTab++;
    });
  }

  void _switchToPreviousTab() {
    setState(() {
      _activeTab -= 1;
    });
  }

  bool get _isNextEnabled {
    if (_activeTab == 0) return _gameMode != null;
    if (_activeTab == 1) return _numberOfPlayers != null;
    if (_activeTab == 2 && _gameMode == GameMode.token) {
      return _selectedTokenAddress != null && _selectedTokenAmount != null;
    }
    if (_activeTab == 2 && _gameMode == GameMode.free) {
      return _playerColor != null;
    }
    if (_activeTab == 3) return _playerColor != null;
    return false;
  }

  int get _numberOfTabs => 3;

  Future<void> _createGame() async {
    final game = ModalRoute.of(context)!.settings.arguments as LudoGame;
    final color =
        _playerColor!.split("/").last.split(".").first.split("_").first;
    try {
      setState(() {
        _isLoading = true;
      });
      await ref.read(ludoSessionProvider.notifier).createSession(
            _gameMode == GameMode.free ? '0' : '$_selectedTokenAmount',
            color,
            _selectedTokenAddress ?? "0",
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      game.playState = PlayState.waiting;
    } catch (e) {
      if (!context.mounted) return;
      showErrorDialog(e.toString(), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

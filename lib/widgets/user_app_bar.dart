import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquis_v2/dialog/deposit_dialog.dart';
import 'package:marquis_v2/providers/user.dart';

import 'user_points_widget.dart';

class UserAppbar extends ConsumerStatefulWidget {
  const UserAppbar({super.key});

  @override
  ConsumerState<UserAppbar> createState() => _UserAppbarState();
}

class _UserAppbarState extends ConsumerState<UserAppbar> {
  late final user = ref.watch(userProvider);
  bool _showBalance = false;

  void _toggleBalanceVisibility() => setState(() => _showBalance = !_showBalance);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0x120f1118),
        Color(0x12999999),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const UserPointsWidget(),
          const SizedBox(width: 8),
          Container(
            width: 2,
            height: 30,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xff00ECFF), Color(0xff000000)],
                center: Alignment.center,
                radius: 10.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          user == null
              ? Container()
              : Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: const BorderRadius.all(Radius.circular(8.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: _toggleBalanceVisibility,
                              child: SizedBox(width: 18, height: 20, child: FittedBox(child: Icon(_showBalance ? Icons.visibility : Icons.visibility_off))),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/svg/STRK_logo.svg", width: 19),
                                    const SizedBox(width: 4),
                                    const Text('STRK', style: TextStyle(color: Colors.white, fontSize: 10))
                                  ],
                                ),
                                const SizedBox(width: 5),
                                FutureBuilder<BigInt>(
                                  future: ref.read(userProvider.notifier).getTokenBalance("0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d"),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Transform.scale(scale: 0.1, child: const CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Container();
                                    }
                                    return Text(
                                      _showBalance
                                          ? ((snapshot.data! / BigInt.from(1e18))
                                              .toStringAsFixed(8)
                                              .replaceAll(RegExp(r'0+$'), '')
                                              .replaceAll(RegExp(r'\.$'), ''))
                                          : '********',
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 2,
                              height: 30,
                              decoration: const BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [Color(0xff00ECFF), Color(0xff000000)],
                                  center: Alignment.center,
                                  radius: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/images/eth_icon.png", width: 19),
                                    const SizedBox(width: 4),
                                    const Text('ETH', style: TextStyle(color: Colors.white, fontSize: 10))
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _showBalance ? '0' : '********',
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 2,
                              height: 30,
                              decoration: const BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [Color(0xff00ECFF), Color(0xff000000)],
                                  center: Alignment.center,
                                  radius: 10.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/images/lords_icon.png", width: 19),
                                    const SizedBox(width: 4),
                                    const Text('LORDS', style: TextStyle(color: Colors.white, fontSize: 10))
                                  ],
                                ),
                                const SizedBox(width: 5),
                                Text(_showBalance ? '0' : '********', style: const TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                showDialog(context: context, builder: (_) => const DepositDialog());
                              },
                              child: const Icon(Icons.add, size: 24, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

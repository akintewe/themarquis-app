import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquis_v2/providers/user.dart';

import 'gradient_separator.dart';
import 'user_points_widget.dart';

class BalanceAppBar extends StatefulWidget {
  const BalanceAppBar({super.key});

  @override
  State<BalanceAppBar> createState() => _BalanceAppBarState();
}

class _BalanceAppBarState extends State<BalanceAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const UserPointsWidget(),
              const SizedBox(width: 8.0),
              ref.read(userProvider) == null
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
                                    onTap: ref.read(userProvider.notifier).toggleBalanceVisibility,
                                    child: SvgPicture.asset(
                                        ref.read(userProvider.notifier).isBalanceVisible ? 'assets/svg/eye_icon.svg' : 'assets/svg/hide_icon.svg',
                                        width: 18,
                                        height: 20)),
                                const SizedBox(width: 8.0),
                                const GradientSeparator(),
                                const SizedBox(width: 8.0),
                                SizedBox(
                                  width: 75,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset("assets/svg/STRK_logo.svg", width: 19),
                                          const SizedBox(width: 4.0),
                                          const Text('STRK', style: TextStyle(color: Colors.white, fontSize: 10))
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      FutureBuilder<BigInt>(
                                        future: ref
                                            .read(userProvider.notifier)
                                            .getTokenBalance("0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d"),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Transform.scale(scale: 0.2, child: const CircularProgressIndicator());
                                          }
                                          if (snapshot.hasError) {
                                            return Container();
                                          }
                                          return Text(
                                            ref.read(userProvider.notifier).isBalanceVisible
                                                ? ((snapshot.data! / BigInt.from(1e18))
                                                    .toStringAsFixed(8)
                                                    .replaceAll(RegExp(r'0+$'), '')
                                                    .replaceAll(RegExp(r'\.$'), ''))
                                                : '********',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                const GradientSeparator(),
                                const SizedBox(width: 8.0),
                                SizedBox(
                                  width: 75,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/images/eth_icon.png", width: 19),
                                          const SizedBox(width: 4.0),
                                          const Text('ETH', style: TextStyle(color: Colors.white, fontSize: 10))
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      FutureBuilder<BigInt>(
                                        future: ref
                                            .read(userProvider.notifier)
                                            .getTokenBalance("0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7"),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Transform.scale(scale: 0.2, child: const CircularProgressIndicator());
                                          }
                                          if (snapshot.hasError) {
                                            return Container();
                                          }
                                          return Text(
                                            ref.read(userProvider.notifier).isBalanceVisible
                                                ? ((snapshot.data! / BigInt.from(1e18))
                                                    .toStringAsFixed(8)
                                                    .replaceAll(RegExp(r'0+$'), '')
                                                    .replaceAll(RegExp(r'\.$'), ''))
                                                : '********',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                const GradientSeparator(),
                                const SizedBox(width: 8.0),
                                SizedBox(
                                  width: 75,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/images/lords_icon.png", width: 19),
                                          const SizedBox(width: 4.0),
                                          const Text('LORDS', style: TextStyle(color: Colors.white, fontSize: 10))
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      Text(ref.read(userProvider.notifier).isBalanceVisible ? '0' : '********',
                                          style: const TextStyle(color: Colors.white, fontSize: 10)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const GradientSeparator(),
                                const SizedBox(width: 8.0),
                                SizedBox(
                                  width: 75,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/images/brother_logo.png", width: 19),
                                          const SizedBox(width: 4.0),
                                          const Text(
                                            'BROTHER',
                                            style: TextStyle(color: Colors.white, fontSize: 10),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 5),
                                      Text(ref.read(userProvider.notifier).isBalanceVisible ? '0' : '********',
                                          style: const TextStyle(color: Colors.white, fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquis_v2/dialog/deposit_dialog.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:marquis_v2/router/route_path.dart';
import 'package:marquis_v2/dialog/auth_dialog.dart';
import 'package:marquis_v2/widgets/locked_game_widget.dart';
import 'package:marquis_v2/widgets/ui_widgets.dart';

import '../widgets/user_points_widget.dart';

class HomePath extends AppRoutePath {
  @override
  String getRouteInformation() {
    return '/';
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  bool showBalance = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 64,
                ),
                Image.asset(
                  'assets/images/banner.png',
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
            Column(
              children: [
                AppBar(
                  backgroundColor: Colors.white.withOpacity(0.02),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const UserPointsWidget(),
                        horizontalSpace(8.0),
                        user == null
                            ? Container()
                            : Expanded(
                              child: Container(
                                 decoration: BoxDecoration(
                                   color: Colors.white.withOpacity(0.1),
                                   borderRadius: const BorderRadius.all(Radius.circular(8.0))
                                 ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            setState(() {
                                              showBalance = !showBalance;
                                            });
                                          },
                                            child: SvgPicture.asset(
                                              showBalance ?
                                                'assets/svg/eye_icon.svg' : 'assets/svg/hide_icon.svg',
                                                width: 18, height: 20
                                            )
                                        ),
                                        horizontalSpace(8.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/STRK_logo.svg",
                                                  width: 19,
                                                ),
                                                const Text(
                                                  'STRK',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            FutureBuilder<BigInt>(
                                              future: ref.read(userProvider.notifier).getTokenBalance(
                                                  "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d"),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Transform.scale(
                                                    scale: 0.2,
                                                      child: const CircularProgressIndicator());
                                                }
                                                if (snapshot.hasError) {
                                                  return Container();
                                                }
                                                return Text(
                                                  showBalance ?
                                                  ((snapshot.data! / BigInt.from(1e18))
                                                      .toStringAsFixed(8)
                                                      .replaceAll(RegExp(r'0+$'), '')
                                                      .replaceAll(RegExp(r'\.$'), '')) : '********',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        horizontalSpace(12.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/eth_icon.png",
                                                  width: 19,
                                                ),
                                                const Text(
                                                  'ETH',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              showBalance ? '0' : '********',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        horizontalSpace(12.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/lords_icon.png",
                                                  width: 19,
                                                ),
                                                const Text(
                                                  'LORDS',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                                showBalance ? '0' : '********',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                )
                                            ),
                                          ],
                                        ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (c) {
                                              return const DepositDialog();
                                            });
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        size: 24,
                                        color: Colors.white,
                                      ),
                                    )
                                                            ],
                                                          ),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                const ListTile(
                  title: Text(
                    'Top picks',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    'Lets explore our games',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Image.asset('assets/images/ludo.png',
                                fit: BoxFit.fitWidth,
                                color: Colors.black.withAlpha(100),
                                colorBlendMode: BlendMode.darken),
                            const Positioned(
                              bottom: 0,
                              left: 0,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Dice Game',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      'Ludo',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: IconButton(
                                  onPressed: () {
                                    if (!ref.read(appStateProvider).isAuth) {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) => const AuthDialog());
                                      return;
                                    }
                                    ref
                                        .read(appStateProvider.notifier)
                                        .selectGame("ludo");
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 32,
                                  ),
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withAlpha(100),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                                color: const Color(0xff181B25)
                            )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpace(8.0),
                            const LockedGameWidget(
                              title: 'Checkers',
                              subTitle: 'Board Game',
                              image: 'assets/images/checkers.png',
                            ),
                            const LockedGameWidget(
                              title: 'Yahtzee',
                              subTitle: 'Dice Game',
                              image: 'assets/images/yahtzee.png',
                            ),
                            const LockedGameWidget(
                              title: '6 nimmt',
                              subTitle: 'Card Game',
                              image: 'assets/images/6nimmt.png',
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: SvgPicture.asset(
                          'assets/svg/locked_badge.svg',
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String gameType;
  final String imagePath;
  final bool isActive;
  final bool isPopular;
  final Function()? onPlay;

  const GameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gameType,
    required this.imagePath,
    required this.isActive,
    required this.isPopular,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          width: 220,
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  imagePath,
                  width: 220,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ), // Replace with the actual asset
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: MyChip(
                          title: gameType,
                          icon: FontAwesomeIcons.dice,
                          isLightColor: true,
                          color: Theme.of(context).colorScheme.primary,
                          iconPadding: 8,
                        ),
                      ),
                      if (isPopular)
                        const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: MyChip(
                            title: 'Hot',
                            icon: Icons.local_fire_department,
                            isLightColor: false,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (isActive)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: MyChip(
                              title: '300+ Players',
                              icon: Icons.people,
                              isLightColor: false,
                              color: Colors.transparent,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isActive)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 1.8,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                    ),
                    onPressed: () {
                      if (onPlay != null) {
                        onPlay!();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'PLAY',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyChip extends StatelessWidget {
  const MyChip({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.isLightColor,
    this.iconPadding = 4,
  });
  final IconData icon;
  final String title;
  final Color color;
  final bool isLightColor;
  final double iconPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, iconPadding, 0),
            child: Icon(
              icon,
              color: isLightColor
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              size: 15,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: isLightColor
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquis_v2/dialog/deposit_dialog.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:marquis_v2/router/route_path.dart';
import 'package:marquis_v2/dialog/auth_dialog.dart';

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
                  backgroundColor: Colors.transparent,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: user == null
                            ? () {
                                showDialog(
                                    context: context,
                                    builder: (c) => const AuthDialog());
                              }
                            : () {
                                //go to profile page
                              },
                        child: Row(
                          children: [
                            user == null
                                ? const Icon(
                                    Icons.account_circle,
                                    size: 25,
                                  )
                                : const CircleAvatar(
                                    radius: 15,
                                    backgroundImage: AssetImage(
                                      'assets/images/avatar.png',
                                    ), // Add your avatar image in assets folder
                                    backgroundColor: Colors.transparent,
                                  ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              user == null ? "LOGIN" : user.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            child: Image.asset('assets/images/member.png'),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            user?.points.toString() ?? "0",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 15),
                          SvgPicture.asset(
                            "assets/svg/STRK_logo.svg",
                            width: 19,
                          ),
                          const SizedBox(width: 5),
                          FutureBuilder<int>(
                            future: ref.read(userProvider.notifier).getTokenBalance(
                                "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Container();
                              }
                              return Text(
                                (snapshot.data! / 1e18).toStringAsPrecision(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              );
                            },
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
                    ],
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
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/yahtzee.png',
                                fit: BoxFit.fitWidth,
                                width: 64,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Yahtzee',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Dice Game',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.cyan),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0)),
                            child: const Text(
                              'Comming Soon',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/6nimmt.png',
                                fit: BoxFit.fitWidth,
                                width: 64,
                              ),
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '6 nimmt',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Card Game',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                side: const BorderSide(color: Colors.cyan),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0)),
                            child: const Text(
                              'Comming Soon',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
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

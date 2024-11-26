import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquis_v2/dialog/auth_dialog.dart';
import 'package:marquis_v2/games/ludo/ludo_game.dart';
import 'package:marquis_v2/providers/user.dart';

class WelcomeTopBar extends StatelessWidget {
  final LudoGame game;

  const WelcomeTopBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final user = ref.watch(userProvider);
        return Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              // User Avatar and Points
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.transparent,
                    backgroundImage: user == null
                        ? null
                        : const AssetImage('assets/images/avatar.png'),
                    child: user == null
                        ? const Icon(Icons.account_circle,
                            size: 30, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.email.split("@").first ?? "Vy123",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/member.png',
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${user?.points ?? 8000} Pts.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // Tokens
              Row(
                children: [
                  _buildTokenContainer(
                    "assets/images/STRK_logo.png",
                    ref,
                    "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d",
                  ),
                  const SizedBox(width: 12),
                  _buildTokenContainer(
                    "assets/images/ETH_logo.png",
                    ref,
                    "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d",
                  ),
                  const SizedBox(width: 12),
                  _buildTokenContainer(
                    "assets/images/LC_logo.png",
                    ref,
                    "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTokenContainer(String assetPath, WidgetRef ref, String tokenAddress) {
    // Extract token name from asset path
    String tokenName = assetPath.split('/').last.split('_').first;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(
              assetPath,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 4),
            Text(
              tokenName,  // Token name (STRK, ETH, LC)
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        FutureBuilder<BigInt>(
          future: ref.read(userProvider.notifier).getTokenBalance(tokenAddress),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              );
            }
            return Text(
              '888',  // Replace with actual formatted balance
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            );
          },
        ),
      ],
    );
  }
} 
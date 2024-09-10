import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:marquis_v2/router/route_path.dart';
import 'package:marquis_v2/screens/auth_screen.dart';

class ProfilePath extends AppRoutePath {
  @override
  String getRouteInformation() {
    return '/profile';
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? Center(
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
                  onPressed: () async {
                    showDialog(
                        context: context, builder: (ctx) => const AuthDialog());
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/avatar.png'), // Add your avatar image in assets folder
                    backgroundColor: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      user.email,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Referral Code',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.referralCode,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Joined Date',
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat.yMMMMd().format(user.createdAt),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(appStateProvider.notifier)
                                    .logout();
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('LOGOUT'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

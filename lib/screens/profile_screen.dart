import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:marquis_v2/router/route_path.dart';
import 'package:marquis_v2/dialog/auth_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 8.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SelectableText(
                                    user.accountAddress,
                                    style: const TextStyle(fontSize: 8),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Invite your friends'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: QrImageView(
                                      data: user.referralCode,
                                      size: 128,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: user.referralCode),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        labelText: 'Referral Code',
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.copy),
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: user.referralCode));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Referral code copied to clipboard')),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                          elevation: 8.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.share),
                                ),
                                Text('Show Referral Code'),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Text('Help and Support'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Contact us at support@marquis.com"),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Card(
                          elevation: 8.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.help),
                                ),
                                Text('Help and Support'),
                              ],
                            ),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        ref.read(appStateProvider.notifier).logout();
                      },
                      child: Card(
                          elevation: 8.0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: const Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

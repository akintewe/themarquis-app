import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/providers/user.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isRun = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: () async {
        if (isRun) return;
        isRun = true;
        print("getting user");
        // final connectivityResult = await Connectivity().checkConnectivity();
        // if (connectivityResult == ConnectivityResult.none) {
        //   ref.read(appStateProvider.notifier).setConnectivity(false);
        // } else {
        //   ref.read(appStateProvider.notifier).setConnectivity(true);
        // }
        if (ref.read(appStateProvider).autoLoginResult == null) {
          await ref.read(appStateProvider.notifier).tryAutoLogin();
        }
        await ref.read(userProvider.notifier).getUser();
        // if (ref.read(userProvider) != null) {
        //   ref.read(appStateProvider.notifier).setAutoLogin(true);
        //   ref.read(appStateProvider.notifier).syncServer();
        // }
      }(), builder: (context, snapshot) {
        return Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Image.asset('assets/images/marquis.png'),
              ),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              if (ref.watch(userProvider) == null)
                const Text("Fetching user..."),
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
                    ref.read(appStateProvider.notifier).logout();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Back To Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:magic_sdk/magic_sdk.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/router/route_path.dart';
import 'package:marquis_v2/widgets/error_dialog.dart';

class AuthPath extends AppRoutePath {
  @override
  String getRouteInformation() {
    return '/auth';
  }
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _refCodeController = TextEditingController();
  String? _emailError;
  String? _refCodeError;
  bool _isLoading = false;
  bool _isSignUp = false;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Card(
              elevation: 8.0,
              child: Container(
                width: deviceSize.aspectRatio > 1
                    ? deviceSize.width * 0.5
                    : deviceSize.width * 0.85,
                margin: const EdgeInsets.all(16.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          label: const Text("Email"),
                          errorText: _emailError,
                        ),
                        controller: _emailController,
                      ),
                    ),
                    AnimatedSize(
                      duration: Duration(
                        milliseconds: 100,
                      ),
                      alignment: Alignment.centerRight,
                      child: _isSignUp
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  label: const Text("Referral Code"),
                                  errorText: _refCodeError,
                                ),
                                controller: _refCodeController,
                              ),
                            )
                          : const SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      width: 1.8,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (_isSignUp) {
                                      //sign up
                                      try {
                                        await ref
                                            .read(appStateProvider.notifier)
                                            .signup(
                                              _emailController.text,
                                              _refCodeController.text,
                                            );
                                      } catch (e) {
                                        showErrorDialog(e.toString(), context);
                                      }
                                    } else {
                                      //login
                                      try {
                                        await ref
                                            .read(appStateProvider.notifier)
                                            .login(_emailController.text);
                                      } catch (e) {
                                        showErrorDialog(e.toString(), context);
                                      }
                                    }

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      _isSignUp ? 'Sign Up' : 'Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSignUp = !_isSignUp;
                                    });
                                  },
                                  child: Text(
                                    _isSignUp ? "Back to Login" : "Sign Up",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // Magic.instance.relayer
        ],
      ),
    );
  }
}

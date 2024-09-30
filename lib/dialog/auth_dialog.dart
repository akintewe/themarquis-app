import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:magic_sdk/magic_sdk.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/widgets/error_dialog.dart';

class AuthDialog extends ConsumerStatefulWidget {
  const AuthDialog({super.key});

  @override
  ConsumerState<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends ConsumerState<AuthDialog> {
  final _emailController = TextEditingController();
  final _refCodeController = TextEditingController();
  String? _emailError;
  String? _refCodeError;
  bool _isLoading = false;
  bool _isSignUp = false;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AlertDialog(
      content: Container(
        width: deviceSize.aspectRatio > 1
            ? deviceSize.width * 0.5
            : deviceSize.width * 0.85,
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
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
              duration: const Duration(
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
                              color: Theme.of(context).colorScheme.primary,
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
                              if (_emailController.text != "" &&
                                  _refCodeController.text != "") {
                                try {
                                  if (!_emailController.text
                                      .endsWith('@test.com')) {
                                    await ref
                                        .read(appStateProvider.notifier)
                                        .signup(
                                          _emailController.text,
                                          _refCodeController.text,
                                        );
                                  }
                                  if (!context.mounted) return;
                                  await showDialog<String>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        OTPDialog(
                                      email: _emailController.text,
                                      isSignUp: true,
                                    ),
                                  );
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  showErrorDialog(e.toString(), context);
                                }
                              }
                              //sign up
                            } else {
                              //login
                              if (_emailController.text != "") {
                                try {
                                  if (!_emailController.text
                                      .endsWith('@test.com')) {
                                    await ref
                                        .read(appStateProvider.notifier)
                                        .login(_emailController.text);
                                  }
                                  if (!context.mounted) return;
                                  await showDialog<String>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        OTPDialog(
                                      email: _emailController.text,
                                      isSignUp: false,
                                    ),
                                  );
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  showErrorDialog(e.toString(), context);
                                }
                              }
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _isSignUp ? 'Sign Up' : 'Login',
                              style: const TextStyle(
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
                            style: const TextStyle(
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
    );
  }
}

class OTPDialog extends ConsumerStatefulWidget {
  const OTPDialog({super.key, required this.email, required this.isSignUp});
  final String email;
  final bool isSignUp;

  @override
  ConsumerState<OTPDialog> createState() => _OTPDialogState();
}

class _OTPDialogState extends ConsumerState<OTPDialog> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPDigitChanged(int index) {
    if (_controllers[index].text.length == 1) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter OTP'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
          (index) => SizedBox(
            width: 50,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _onOTPDigitChanged(index),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : TextButton(
                child: const Text('Submit'),
                onPressed: () async {
                  if (_otp.length == 4) {
                    setState(() {
                      _isLoading = true;
                    });
                    final appState = ref.read(appStateProvider.notifier);
                    try {
                      if (widget.email.endsWith('@test.com')) {
                        if (widget.isSignUp) {
                          await appState.signupSandbox(widget.email);
                        } else {
                          await appState.loginSandbox(widget.email);
                        }
                      } else {
                        await appState.verifyCode(widget.email, _otp);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      if (e.toString().contains('Invalid')) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Invalid OTP. Please try again.')),
                        );
                        return; // Don't close the dialog if the code is invalid
                      } else {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('An error occurred. Please try again.')),
                        );
                        return;
                      }
                    }

                    if (!context.mounted) return;
                    Navigator.of(context).pop(_otp);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a 4-digit OTP')),
                    );
                  }
                },
              ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquis_v2/providers/app_state.dart';
import 'package:marquis_v2/widgets/error_dialog.dart';
import 'package:marquis_v2/widgets/primary_button.dart';
import 'package:marquis_v2/widgets/ui_widgets.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import '../widgets/outline_button.dart';
import '../widgets/text_form_field.dart';

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
  bool _emailHasError = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _validateEmail() {
    setState(() {
      if (!_isValidEmail(_emailController.text) && _emailController.text.isNotEmpty) {
        _emailError = 'Invalid email';
        _emailHasError = true;
      } else {
        _emailError = '';
        _emailHasError = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      content: Container(
        width: deviceSize.aspectRatio > 1 ? deviceSize.width * 0.5 : deviceSize.width * 0.85,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset("assets/svg/cancel_icon.svg"))
              ],
            ),
            verticalSpace(4.0),
            const Text("Welcome to The Marquis", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            verticalSpace(24.0),
            CustomTextFormField(
              label: 'Email',
              hintText: 'Input your email',
              controller: _emailController,
              hasError: _emailHasError,
              errorMessage: _emailError,
              onTextChanged: (value) => _validateEmail(),
            ),
            verticalSpace(16.0),
            AnimatedSize(
              duration: const Duration(
                milliseconds: 100,
              ),
              alignment: Alignment.centerRight,
              child: _isSignUp
                  ? CustomTextFormField(
                      label: 'Referral Code',
                      hintText: 'Input your code',
                      controller: _refCodeController,
                      hasError: false,
                      errorMessage: _refCodeError,
                      onTextChanged: (value) {},
                    )
                  : const SizedBox(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        PrimaryButton(
                            isEnabled: _emailController.text.isNotEmpty && !_emailHasError,
                            onTaps: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_isSignUp) {
                                if (_emailController.text != "" && _refCodeController.text != "") {
                                  try {
                                    if (!_emailController.text.endsWith('@test.com')) {
                                      await ref.read(appStateProvider.notifier).signup(
                                            _emailController.text.trim(),
                                            _refCodeController.text.trim(),
                                          );
                                    }
                                    if (!context.mounted) return;
                                    await showDialog<String>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) => OTPDialog(
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
                                    if (!_emailController.text.endsWith('@test.com')) {
                                      await ref.read(appStateProvider.notifier).login(_emailController.text.trim());
                                    }
                                    if (!context.mounted) return;
                                    await showDialog<String>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) => OTPDialog(
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
                            buttonTitle: _isSignUp ? 'Sign Up' : 'Login'),
                        verticalSpace(12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_isSignUp ? "Already have an account? " : "Don’t have an account? ",
                                style: const TextStyle(fontSize: 14, color: Color(0xffCACACA))),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                });
                              },
                              child: Text(
                                _isSignUp ? "Login" : "Sign up",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ],
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
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _submitOTP() {
    _verifyOTP();
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });
    final appState = ref.read(appStateProvider.notifier);
    try {
      if (widget.email.endsWith('@test.com')) {
        if (widget.isSignUp) {
          await appState.signupSandbox(widget.email.trim());
        } else {
          await appState.loginSandbox(widget.email.trim());
        }
      } else {
        await appState.verifyCode(widget.email.trim(), _otpPinFieldController.currentState?.controller.text ?? '');
      }
      if (!mounted) return;
      Navigator.of(context).pop(_otpPinFieldController.currentState?.controller.text);
    } catch (e) {
      if (!mounted) return;
      if (e.toString().contains('Invalid')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8.0),
      content: Container(
        width: deviceSize.aspectRatio > 1 ? deviceSize.width * 0.5 : deviceSize.width * 0.85,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset("assets/svg/cancel_icon.svg"))
              ],
            ),
            verticalSpace(4.0),
            const Text(
              "Verification",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpace(4.0),
            const Text(
              "Verification code has been sent to",
              style: TextStyle(fontSize: 12, color: Color(0xff8E8E8E)),
            ),
            verticalSpace(4.0),
            Text(
              widget.email,
              style: const TextStyle(fontSize: 12, color: Color(0xffF3F3F3)),
            ),
            verticalSpace(16.0),
            OtpPinField(
              key: _otpPinFieldController,
              fieldWidth: 60,
              fieldHeight: 60,
              autoFillEnable: false,
              textInputAction: TextInputAction.done,
              onSubmit: (text) {
                if (text.length == 4) {
                  _submitOTP();
                }
              },
              onChange: (text) {},
              otpPinFieldStyle: OtpPinFieldStyle(
                textStyle: const TextStyle(color: Colors.white),
                activeFieldBorderColor: Theme.of(context).colorScheme.primary,
                defaultFieldBorderColor: const Color(0xff32363A),
                fieldBorderWidth: 1,
              ),
              maxLength: 4,
              showCursor: true,
              cursorColor: Colors.white,
              cursorWidth: 2,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              otpPinFieldDecoration: OtpPinFieldDecoration.defaultPinBoxDecoration,
            ),
            verticalSpace(16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: OutlineButton(
                      onTaps: () => Navigator.of(context).pop(),
                      buttonTitle: 'Cancel',
                    ),
                  ),
                ),
                horizontalSpace(8.0),
                _isLoading
                    ? const CircularProgressIndicator()
                    : Expanded(
                        flex: 1,
                        child: PrimaryButton(
                          onTaps: _submitOTP,
                          buttonTitle: 'Submit',
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

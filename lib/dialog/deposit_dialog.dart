import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquis_v2/providers/user.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DepositDialog extends ConsumerStatefulWidget {
  const DepositDialog({super.key});

  @override
  ConsumerState<DepositDialog> createState() => _DepositDialogState();
}

class _DepositDialogState extends ConsumerState<DepositDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.50 < 100
            ? 100
            : MediaQuery.of(context).size.height * 0.50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  const Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        'DEPOSIT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    const Text(
                      "1.  Login to ",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse("https://themarquis.xyz/"));
                      },
                      child: const Row(
                        children: [
                          Text(
                            "The Marquis Website",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(
                                255,
                                0,
                                236,
                                255,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.arrow_outward,
                            size: 16,
                            color: Color.fromARGB(
                              255,
                              0,
                              236,
                              255,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Text(
                      "2. Deposit to account balance",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Text(
                      "3. Or deposit through QR Code",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: QrImageView(
                  data: ref.read(userProvider)?.accountAddress ?? "",
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

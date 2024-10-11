import 'package:flutter/material.dart';

class MessageOverlay extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final VoidCallback onDismiss;

  const MessageOverlay({
    Key? key,
    required this.message,
    this.backgroundColor = Colors.black87,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 48),
                  onPressed: onDismiss,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

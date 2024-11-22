import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.onTaps,
    required this.buttonTitle,
  });

  final VoidCallback? onTaps;
  final String buttonTitle;


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => onTaps,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          buttonTitle,
          style: const TextStyle(
              fontSize: 16
          ),
        )
    );
  }
}

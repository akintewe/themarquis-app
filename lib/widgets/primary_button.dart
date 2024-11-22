import 'package:flutter/material.dart';


class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    super.key,
    required this.onTaps,
    required this.buttonTitle,
    this.isEnabled = true,
    this.colors,
    this.textColor,
    this.height,
    this.width,
  });
  final VoidCallback? onTaps;
  final bool isEnabled;
  final String buttonTitle;
  final Color? colors;
  final Color? textColor;
  final double? height;
  final double? width;



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: isEnabled ? () => onTaps!() : null,
      child: Container(
        width: width ?? size.width,
        height: 43,
        decoration: BoxDecoration(
          color: isEnabled
              ? (colors ?? Theme.of(context).colorScheme.primary)
              : const Color(0xff32363A),

          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: TextStyle(
              fontSize: 16,
              color: isEnabled
                  ? (textColor ?? Colors.black)
                  : const Color(0XFF939393),
            ),
          ),
        ),
      ),
    );
  }
}
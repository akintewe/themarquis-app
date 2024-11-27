import 'package:flutter/material.dart';

class GradientSeparator extends StatelessWidget {
  const GradientSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 30,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xff00ECFF),
            Color(0xff000000),
          ],
          center: Alignment.center,
          radius: 10.0,
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'corners_only_border.dart';

class PinColorOption extends StatelessWidget {
  final LinearGradient _gradient;
  final String _svgPath;
  final String? _selectedPinColor;
  final void Function(String) _onTap;
  const PinColorOption(
      {required LinearGradient gradient, required String svgPath, required String? selectedPinColor, required void Function(String) onTap, super.key})
      : _gradient = gradient,
        _svgPath = svgPath,
        _selectedPinColor = selectedPinColor,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(_svgPath),
      child: Container(
        width: 44,
        height: 44,
        decoration: ShapeDecoration(
          shape: CornersOnlyBorder(side: BorderSide(color: _selectedPinColor == _svgPath ? Colors.white : Colors.transparent, width: 2)),
          gradient: _gradient,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(_svgPath),
      ),
    );
  }
}

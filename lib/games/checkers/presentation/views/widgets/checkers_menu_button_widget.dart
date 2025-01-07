import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckersMenuButtonWidget extends StatelessWidget {
  final String _label;
  final VoidCallback _onTap;
  final String _icon;
  const CheckersMenuButtonWidget(
      {super.key,
      required String label,
      required String icon,
      required VoidCallback onTap})
      : _label = label,
        _onTap = onTap,
        _icon = icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 268,
            height: 53,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                  colors: [Color(0xFF814809), Color(0xFF0F1118)],
                  stops: [0.6, 1]),
            ),
            padding: const EdgeInsets.only(left: 55),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                SizedBox(height: 4),
                Container(color: const Color(0xFFF3B46E), height: 2, width: 28),
              ],
            ),
          ),
          Positioned(
            left: -38,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF3B46E), width: 3),
                shape: BoxShape.circle,
                color: const Color(0xFF814809),
              ),
              child: Center(
                child: SvgPicture.asset(
                  _icon,
                  width: 17,
                  height: 17,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

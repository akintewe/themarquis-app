import 'package:flutter/material.dart';

class CornersOnlyBorder extends OutlinedBorder {
  static const _defaultBorderSide = BorderSide(color: Color(0xFFFFFFFF), width: 2);
  const CornersOnlyBorder({super.side = _defaultBorderSide});

  @override
  OutlinedBorder copyWith({BorderSide? side}) => CornersOnlyBorder(side: side ?? this.side);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.top);

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    path.moveTo(rect.left, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.top);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    path.moveTo(rect.left, rect.top + rect.height * 0.2);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + rect.width * 0.2, rect.top);

    path.moveTo(rect.right, rect.top + rect.height * 0.2);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right - rect.width * 0.2, rect.top);

    path.moveTo(rect.left, rect.bottom - rect.height * 0.2);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left + rect.width * 0.2, rect.bottom);

    path.moveTo(rect.right, rect.bottom - rect.height * 0.2);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right - rect.width * 0.2, rect.bottom);

    final paint = Paint();

    paint.color = side.color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = side.width;

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) => const CornersOnlyBorder();
}

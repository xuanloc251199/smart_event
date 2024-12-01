import 'package:flutter/material.dart';

class CircleOverlayPainter extends CustomPainter {
  final Offset center;
  final double radius;

  CircleOverlayPainter({
    required this.center,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ màn phủ mờ
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // "Đục" một hình tròn
    final holePaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawCircle(center, radius, holePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

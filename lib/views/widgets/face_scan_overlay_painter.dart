import 'package:flutter/material.dart';

class FaceScanOverlayPainter extends CustomPainter {
  final Offset circleCenter;
  final double circleRadius;
  final Color overlayColor;
  final Color circleColor;

  FaceScanOverlayPainter({
    required this.circleCenter,
    required this.circleRadius,
    required this.overlayColor,
    required this.circleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint overlayPaint = Paint()
      ..color = overlayColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final Paint circlePaint = Paint()
      ..color = circleColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Vẽ overlay toàn màn hình
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Vẽ vòng tròn cắt
    canvas.drawCircle(circleCenter, circleRadius, circlePaint);
  }

  @override
  bool shouldRepaint(FaceScanOverlayPainter oldDelegate) {
    return oldDelegate.circleCenter != circleCenter ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.circleColor != circleColor;
  }
}

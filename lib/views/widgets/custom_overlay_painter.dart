import 'package:flutter/material.dart';

class FaceScanOverlayPainter extends CustomPainter {
  final Offset circleCenter;
  final double circleRadius;
  final Color circleColor;
  final Color overlayColor;

  FaceScanOverlayPainter({
    required this.circleCenter,
    required this.circleRadius,
    required this.circleColor,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    // Draw full screen overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Clear circular area
    final circlePaint = Paint()
      ..color = overlayColor
      ..blendMode = BlendMode.clear;

    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    // Draw circular border
    final borderPaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(circleCenter, circleRadius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

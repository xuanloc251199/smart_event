import 'package:flutter/material.dart';
import 'circle_overlay_painter.dart';

class FaceOverlay extends StatelessWidget {
  const FaceOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final centerX = width / 2;
        final centerY = height / 2;
        final radius = width * 0.35;
        // Tuỳ chỉnh bán kính (0.35 ~ 35% chiều rộng)

        return CustomPaint(
          size: Size(width, height),
          painter: CircleOverlayPainter(
            center: Offset(centerX, centerY),
            radius: radius,
          ),
        );
      },
    );
  }
}

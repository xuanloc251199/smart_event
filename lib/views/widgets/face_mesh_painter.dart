import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';

class FaceMeshPainter extends CustomPainter {
  final List<FaceMesh> meshes;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  FaceMeshPainter({
    required this.meshes,
    required this.imageSize,
    required this.rotation,
    required this.cameraLensDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final mesh in meshes) {
      for (final contour in mesh.allContours) {
        final points =
            contour.map((point) => _transformPoint(point, size)).toList();

        for (int i = 0; i < points.length - 1; i++) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
        // Đóng contour
        if (points.isNotEmpty) {
          canvas.drawLine(points.last, points.first, paint);
        }
      }
    }
  }

  Offset _transformPoint(FaceMeshPoint point, Size canvasSize) {
    double scaleX = canvasSize.width / imageSize.width;
    double scaleY = canvasSize.height / imageSize.height;

    double x = point.x * scaleX;
    double y = point.y * scaleY;

    // Đối với camera trước, lật hình ảnh lại
    if (cameraLensDirection == CameraLensDirection.front) {
      x = canvasSize.width - x;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(FaceMeshPainter oldDelegate) {
    return oldDelegate.meshes != meshes;
  }
}

extension on FaceMesh {
  get allContours => null;
}

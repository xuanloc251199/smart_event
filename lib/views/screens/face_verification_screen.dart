import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/face_verification_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/resources/colors.dart';

class FaceVerificationScreen extends StatelessWidget {
  final FaceVerificationController controller =
      Get.put(FaceVerificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Camera Preview
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateY(controller.isFrontCamera ? 3.14159 : 0),
              child: CameraPreview(controller.cameraController!),
            ),

            // Overlay with circular indicator
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: FaceScanOverlayPainter(
                circleCenter: Offset(50.w, 33.3.h),
                circleRadius: 40.w,
                circleColor:
                    controller.isFaceDetected.value ? Colors.green : Colors.red,
                overlayColor: AppColors.primaryColor.withOpacity(0.5),
              ),
            ),

            // Status message
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Obx(() {
                return Text(
                  controller.statusMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                );
              }),
            ),

            // Verify Button
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.captureAndVerifyFace();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Obx(() {
                    return controller.isUploading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Verify Face");
                  }),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

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

    // Overlay toàn màn hình
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Xóa vùng tròn
    final circlePaint = Paint()
      ..color = overlayColor
      ..blendMode = BlendMode.clear;

    canvas.drawCircle(circleCenter, circleRadius, circlePaint);

    // Viền tròn
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

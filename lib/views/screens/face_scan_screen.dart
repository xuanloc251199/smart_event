import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/controllers/face_scan_controller.dart';

class FaceScanScreen extends StatelessWidget {
  final FaceScanController controller = Get.find<FaceScanController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: CameraPreview(controller.cameraController!)),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Obx(() => Text(
                        controller.statusMessage.value,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      controller.isUploading.value
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () =>
                                  controller.captureAndUploadFace(),
                              child: Text('Lưu Khuôn Mặt'),
                            ),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: Text('Thoát'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/controllers/face_scan_controller.dart';

class FaceEnrollScreen extends StatelessWidget {
  final FaceScanController controller = Get.find<FaceScanController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Stack(
            children: [
              // Camera
              CameraPreview(controller.cameraController!),

              // Status
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    controller.statusMessage.value,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Nút chụp
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Obx(() {
                    if (controller.isUploading.value) {
                      return const CircularProgressIndicator();
                    } else {
                      return ElevatedButton(
                        onPressed: () => controller.captureAndUploadFace(),
                        child: const Text('Chụp & Lưu Face'),
                      );
                    }
                  }),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

import 'package:camera/camera.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/controllers/face_verify_controller.dart';

class FaceVerifyScreen extends StatelessWidget {
  final FaceVerifyController controller = Get.find<FaceVerifyController>();
  final EventController eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    final String eventId = Get.arguments;
    print('Event Id: $eventId');
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Verification'),
      ),
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
                  Text(controller.statusMessage.value),
                  ElevatedButton(
                    onPressed: () {
                      if (eventId != '') {
                        controller.captureAndVerifyFace(eventId);
                      }
                    },
                    child: Text('Verify Face'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

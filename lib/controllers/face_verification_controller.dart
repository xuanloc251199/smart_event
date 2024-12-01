// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// class FaceVerificationController extends GetxController {
//   CameraController? cameraController;
//   RxBool isCameraInitialized = false.obs;
//   RxBool isFaceDetected = false.obs;
//   RxString statusMessage = 'Initializing...'.obs;
//   RxBool isUploading = false.obs;

//   // Thêm biến kiểm tra camera trước
//   bool get isFrontCamera =>
//       cameraController?.description.lensDirection == CameraLensDirection.front;

//   final FaceDetector faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableContours: true,
//       enableClassification: true,
//     ),
//   );

//   @override
//   void onInit() {
//     super.onInit();
//     initializeCamera();
//   }

//   @override
//   void onClose() {
//     cameraController?.dispose();
//     faceDetector.close();
//     super.onClose();
//   }

//   Future<void> initializeCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );

//       cameraController = CameraController(
//         frontCamera,
//         ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await cameraController!.initialize();
//       isCameraInitialized.value = true;

//       startFaceDetection();
//     } catch (e) {
//       statusMessage.value = 'Error initializing camera: $e';
//     }
//   }

//   Future<void> startFaceDetection() async {
//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       return;
//     }

//     cameraController!.startImageStream((CameraImage image) async {
//       try {
//         final WriteBuffer allBytes = WriteBuffer();
//         for (final Plane plane in image.planes) {
//           allBytes.putUint8List(plane.bytes);
//         }
//         final bytes = allBytes.done().buffer.asUint8List();

//         final inputImage = InputImage.fromBytes(
//           bytes: bytes,
//           metadata: InputImageMetadata(
//             size: Size(image.width.toDouble(), image.height.toDouble()),
//             rotation: InputImageRotation.rotation0deg,
//             format: InputImageFormat.nv21,
//             bytesPerRow: image.planes[0].bytesPerRow,
//           ),
//         );

//         final faces = await faceDetector.processImage(inputImage);
//         isFaceDetected.value = faces.isNotEmpty;
//         statusMessage.value =
//             isFaceDetected.value ? 'Face detected!' : 'No face detected.';
//       } catch (e) {
//         statusMessage.value = 'Error detecting face: $e';
//       }
//     });
//   }

//   Future<void> captureAndVerifyFace() async {
//     if (!isFaceDetected.value) {
//       statusMessage.value = 'No face detected. Cannot verify.';
//       return;
//     }

//     // Add logic to verify face with existing data
//     statusMessage.value = 'Face verified successfully!';
//   }
// }

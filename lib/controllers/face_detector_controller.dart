// import 'dart:io';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

// class FaceDetectionController extends GetxController {
//   CameraController? cameraController;
//   late CameraDescription cameraDescription;

//   // Trạng thái camera
//   RxBool isCameraInitialized = false.obs;
//   RxBool isDetecting = false.obs;
//   RxString statusMessage = 'Initializing...'.obs;

//   // Danh sách Face (bounding boxes, landmarks)
//   RxList<Face> detectedFaces = <Face>[].obs;

//   // Danh sách FaceMesh
//   RxList<FaceMesh> detectedFaceMeshes = <FaceMesh>[].obs;

//   // MLKit instance
//   final faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableClassification: false,
//       enableTracking: true,
//       enableLandmarks: false,
//       enableContours: true,
//     ),
//   );

//   // FaceMeshDetector (experimental)
//   final faceMeshDetector = FaceMeshDetector(
//     option: FaceMeshDetectorOption(
//       enableFaceMesh: true,
//     ),
//   );

//   @override
//   void onInit() {
//     super.onInit();
//     initCamera();
//   }

//   @override
//   void onClose() {
//     cameraController?.dispose();
//     faceDetector.close();
//     faceMeshDetector.close();
//     super.onClose();
//   }

//   /// Khởi tạo camera, tìm camera trước nếu có
//   Future<void> initCamera() async {
//     try {
//       final cameras = await availableCameras();
//       // Tìm camera trước
//       cameraDescription = cameras.firstWhere(
//         (c) => c.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );

//       cameraController = CameraController(
//         cameraDescription,
//         ResolutionPreset.high,
//         enableAudio: false,
//       );

//       await cameraController!.initialize();
//       isCameraInitialized.value = true;

//       // Bắt đầu stream frame để detect
//       startImageStream();

//       statusMessage.value = 'Camera initialized!';
//     } catch (e) {
//       statusMessage.value = 'Error init camera: $e';
//     }
//   }

//   /// Lắng nghe frame camera -> detect khuôn mặt
//   void startImageStream() {
//     if (cameraController == null) return;

//     cameraController!.startImageStream((CameraImage image) async {
//       if (isDetecting.value) return; // tránh "chồng" detect
//       isDetecting.value = true;

//       try {
//         // Convert CameraImage -> InputImage (cho Google ML Kit)
//         final inputImage = _convertCameraImage(image, cameraDescription.sensorOrientation);
//         if (inputImage == null) {
//           isDetecting.value = false;
//           return;
//         }

//         // Face detection
//         final faces = await faceDetector.processImage(inputImage);

//         // Face mesh detection
//         final faceMeshes = await faceMeshDetector.processImage(inputImage);

//         detectedFaces.assignAll(faces);
//         detectedFaceMeshes.assignAll(faceMeshes);

//       } catch (err) {
//         // debugPrint('Error detecting face: $err');
//       } finally {
//         isDetecting.value = false;
//       }
//     });
//   }

//   /// Chụp ảnh tĩnh (nếu cần)
//   Future<File?> takePicture() async {
//     if (!isCameraInitialized.value || cameraController == null) {
//       return null;
//     }
//     try {
//       final xFile = await cameraController!.takePicture();
//       return File(xFile.path);
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Chuyển CameraImage -> InputImage
//   /// Lưu ý: google_ml_kit yêu cầu NV21 / YUV -> convert sang format
//   /// Dưới đây là ví dụ "thủ công" (chỉ minh hoạ)
//   InputImage? _convertCameraImage(CameraImage image, int rotation) {
//     try {
//       final allBytes = WriteBuffer();
//       for (final plane in image.planes) {
//         allBytes.putUint8List(plane.bytes);
//       }
//       final bytes = allBytes.done().buffer.asUint8List();

//       final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

//       final imageRotation = _imageRotationFromCameraRotation(rotation);

//       final planeData = image.planes.map(
//         (plane) => InputImagePlaneMetadata(
//           bytesPerRow: plane.bytesPerRow,
//           height: image.height,
//           width: image.width,
//         ),
//       ).toList();

//       final inputImageData = InputImageData(
//         size: imageSize,
//         imageRotation: imageRotation,
//         inputImageFormat: InputImageFormatMethods.fromRawValue(image.format.raw)
//             ?? InputImageFormat.nv21,
//         planeData: planeData,
//       );

//       return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Map từ góc xoay camera -> góc xoay MLKit
//   InputImageRotation _imageRotationFromCameraRotation(int rotation) {
//     switch (rotation) {
//       case 0:
//         return InputImageRotation.rotation0deg;
//       case 90:
//         return InputImageRotation.rotation90deg;
//       case 180:
//         return InputImageRotation.rotation180deg;
//       case 270:
//         return InputImageRotation.rotation270deg;
//       default:
//         return InputImageRotation.rotation0deg;
//     }
//   }
// }

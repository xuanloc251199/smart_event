// import 'dart:convert';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:get/get.dart';
// import '../services/api_service.dart';

// class FaceDataController extends GetxController {
//   late CameraController cameraController;
//   var isCameraInitialized = false.obs;
//   var isProcessing = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     cameraController = CameraController(
//       cameras.first,
//       ResolutionPreset.medium,
//     );
//     await cameraController.initialize();
//     isCameraInitialized.value = true;
//   }

//   Future<void> captureAndUploadFaceData(String token) async {
//     if (isProcessing.value) return;

//     try {
//       isProcessing.value = true;
//       final file = await cameraController.takePicture();
//       final imageFile = File(file.path);

//       // Tạm thời tạo dữ liệu mesh (bạn có thể thay bằng dữ liệu thật từ detector)
//       final meshData = {
//         "mesh_points": [
//           [100, 150],
//           [200, 250]
//         ], // Ví dụ
//         "timestamp": DateTime.now().toIso8601String()
//       };

//       final formData = dio.FormData.fromMap({
//         'face_image': await dio.MultipartFile.fromFile(imageFile.path),
//         'mesh_data': json.encode(meshData),
//       });

//       final apiService = ApiService();
//       final response = await apiService.post(
//         '/save-face-data',
//         formData,
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar('Thành công', 'Dữ liệu khuôn mặt đã được lưu.');
//       } else {
//         Get.snackbar('Lỗi', 'Không thể lưu dữ liệu khuôn mặt.');
//       }
//     } catch (e) {
//       Get.snackbar('Lỗi', 'Đã xảy ra lỗi: $e');
//     } finally {
//       isProcessing.value = false;
//     }
//   }

//   Future<void> verifyFace(String token) async {
//     // Xử lý xác thực khuôn mặt
//     Get.snackbar(
//         'Tính năng đang phát triển', 'Chức năng xác thực sẽ được thêm sau.');
//   }

//   @override
//   void onClose() {
//     cameraController.dispose();
//     super.onClose();
//   }
// }

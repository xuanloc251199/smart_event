import 'dart:typed_data';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/user_repository.dart';

class FaceScanController extends GetxController {
  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  RxString statusMessage = 'Initializing...'.obs;
  RxBool isUploading = false.obs;
  bool isFrontCamera = true;

  final UserRepository userRepository = Get.find<UserRepository>();

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );
      isFrontCamera = (frontCamera.lensDirection == CameraLensDirection.front);

      await cameraController!.initialize();
      isCameraInitialized.value = true;
      statusMessage.value = 'Camera initialized';
    } catch (e) {
      statusMessage.value = 'Failed to initialize camera: $e';
    }
  }

  Future<void> captureAndUploadFace() async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) {
        statusMessage.value = 'Camera is not initialized';
        return;
      }

      // 1. Chụp ảnh
      final XFile imageFile = await cameraController!.takePicture();
      final Uint8List imageBytes = await File(imageFile.path).readAsBytes();

      // 2. Lật ảnh nếu camera trước
      Uint8List processedImageBytes = imageBytes;
      if (isFrontCamera) {
        processedImageBytes = await flipImageHorizontally(imageBytes);
      }

      // 3. Lưu vào file tạm
      final tempFile = await saveImageToFile(processedImageBytes);

      // 4. Gửi API /save-face-data
      isUploading.value = true;
      final token = await _getToken();

      final formData = dio.FormData.fromMap({
        'face_image': await dio.MultipartFile.fromFile(
          tempFile.path,
          filename: 'face_image.jpg',
        ),
      });

      final response = await userRepository.uploadFaceData(token, formData);

      if (response.statusCode == 200) {
        statusMessage.value = 'Face data uploaded successfully!';
        Get.snackbar('Success', 'Face data saved!');
      } else {
        statusMessage.value = 'Failed to upload face data!';
        Get.snackbar('Error', 'Failed to upload face data: ${response.data}');
      }
    } catch (e) {
      statusMessage.value = 'Error capturing or uploading face: $e';
    } finally {
      isUploading.value = false;
    }
  }

  Future<Uint8List> flipImageHorizontally(Uint8List imageBytes) async {
    final img.Image originalImage = img.decodeImage(imageBytes)!;
    final img.Image flippedImage = img.flipHorizontal(originalImage);
    return Uint8List.fromList(img.encodeJpg(flippedImage));
  }

  Future<File> saveImageToFile(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final filePath =
        '${directory.path}/face_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}

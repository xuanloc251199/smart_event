import 'dart:typed_data';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/repositories/user_repository.dart';

class FaceScanController extends GetxController {
  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  Rx<Uint8List?> capturedFaceData = Rx<Uint8List?>(null);
  RxString statusMessage = 'Initializing...'.obs;
  bool isFrontCamera = true;
  RxBool isUploading = false.obs;

  final UserRepository userRepository;

  FaceScanController(this.userRepository);

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

      isFrontCamera = frontCamera.lensDirection == CameraLensDirection.front;

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

      // Capture image
      final XFile imageFile = await cameraController!.takePicture();
      final Uint8List imageBytes = await File(imageFile.path).readAsBytes();

      // Flip the image if using front camera
      Uint8List processedImageBytes = imageBytes;
      if (isFrontCamera) {
        processedImageBytes = await flipImageHorizontally(imageBytes);
      }

      // Save to DB
      final tempFile = await saveImageToFile(processedImageBytes);
      await uploadFaceData(tempFile);

      statusMessage.value = 'Face uploaded successfully!';
    } catch (e) {
      statusMessage.value = 'Error capturing or uploading face: $e';
    }
  }

  Future<Uint8List> flipImageHorizontally(Uint8List imageBytes) async {
    try {
      final img.Image originalImage = img.decodeImage(imageBytes)!;
      final img.Image flippedImage = img.flipHorizontal(originalImage);
      return Uint8List.fromList(img.encodeJpg(flippedImage));
    } catch (e) {
      throw Exception('Failed to flip image: $e');
    }
  }

  Future<File> saveImageToFile(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/face_image.jpg';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  Future<void> uploadFaceData(File imageFile) async {
    try {
      isUploading.value = true;

      final token = await _getToken();
      final formData = dio.FormData.fromMap({
        'face_image': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: 'face_image.jpg',
        ),
      });

      final response = await userRepository.saveFaceData(token, formData);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Face data uploaded successfully!');
      } else {
        Get.snackbar('Error', 'Failed to upload face data: ${response.data}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload face data: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}

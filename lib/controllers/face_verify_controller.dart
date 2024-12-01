import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/controllers/event_controller.dart';
import '../repositories/user_repository.dart';

class FaceVerifyController extends GetxController {
  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  RxList<FaceMesh> detectedMeshes = <FaceMesh>[].obs;
  RxString statusMessage = 'Initializing...'.obs;
  RxBool isVerifying = false.obs;
  bool isFrontCamera = true;
  bool _isDetecting = false; // Cờ ngăn detect chồng lệnh

  final UserRepository userRepository = Get.find<UserRepository>();

  // Initialize camera and start image stream
  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onClose() {
    _isDetecting = false;
    cameraController?.dispose();
    meshDetector.close(); // Đóng FaceMeshDetector
    super.onClose();
  }

  // Initialize camera
  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
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

      // Initialize FaceMeshDetector
      meshDetector = FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);

      // Start image stream for face mesh detection
      startImageStream();
    } catch (e) {
      statusMessage.value = 'Failed to initialize camera: $e';
      print('Error initializing camera: $e');
    }
  }

  // Initialize FaceMeshDetector with appropriate options
  late FaceMeshDetector meshDetector;

  // Start image stream and process frames
  void startImageStream() {
    cameraController?.startImageStream((CameraImage image) async {
      if (_isDetecting) return;
      _isDetecting = true;

      try {
        final file = await _cameraImageToFile(image);
        final inputImage = await _createInputImageFromFile(file);

        final meshes = await meshDetector.processImage(inputImage);
        detectedMeshes.assignAll(meshes); // Cập nhật list mesh => vẽ UI
      } catch (e) {
        print('Error processing image stream: $e');
      } finally {
        _isDetecting = false;
      }
    });
  }

  // Convert CameraImage to File
  Future<File> _cameraImageToFile(CameraImage image) async {
    try {
      // Chuyển đổi CameraImage sang Uint8List
      final WriteBuffer allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      // Lưu bytes vào file tạm thời
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/camera_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      print('Error converting CameraImage to File: $e');
      rethrow;
    }
  }

  // Create InputImage from File
  Future<InputImage> _createInputImageFromFile(File file) async {
    try {
      final inputImage = InputImage.fromFilePath(file.path);
      return inputImage;
    } catch (e) {
      print('Error creating InputImage from file: $e');
      rethrow;
    }
  }

  // Capture and verify face image
  Future<void> captureAndVerifyFace(String eventId) async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) {
        statusMessage.value = 'Camera is not initialized';
        return;
      }

      // Capture image
      final XFile imageFile = await cameraController!.takePicture();
      Uint8List imageBytes = await File(imageFile.path).readAsBytes();

      // Flip the image if using front camera
      if (isFrontCamera) {
        imageBytes = await flipImageHorizontally(imageBytes);
      }

      // Save to temporary file
      final tempFile = await saveImageToFile(imageBytes);

      // Upload and verify face data
      await verifyFaceData(tempFile, eventId);
    } catch (e) {
      statusMessage.value = 'Error capturing or verifying face: $e';
      Get.snackbar('Error', 'Error capturing or verifying face: $e');
    }
  }

  // Flip image horizontally
  Future<Uint8List> flipImageHorizontally(Uint8List imageBytes) async {
    try {
      final img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) return imageBytes;
      final img.Image flippedImage = img.flipHorizontal(originalImage);
      return Uint8List.fromList(img.encodeJpg(flippedImage));
    } catch (e) {
      throw Exception('Failed to flip image: $e');
    }
  }

  // Save image to temporary file
  Future<File> saveImageToFile(Uint8List imageBytes) async {
    final directory = await getTemporaryDirectory();
    final filePath =
        '${directory.path}/face_verify_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  // Verify face data with server
  Future<void> verifyFaceData(File imageFile, String eventId) async {
    try {
      isVerifying.value = true;
      statusMessage.value = 'Verifying...';

      final token = await _getToken();
      if (token.isEmpty) {
        statusMessage.value = 'User not authenticated';
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      final formData = dio.FormData.fromMap({
        'face_image': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: 'face_verify.jpg',
        ),
      });

      final response = await userRepository.verifyFaceData(token, formData);

      if (response.statusCode == 200) {
        final data = response.data;
        bool matched = data['status'] ?? false;
        if (matched) {
          statusMessage.value = 'Face matched! ✅';
          final eventController = Get.find<EventController>();
          eventController.checkInEvent(eventId);
          Get.back();
          Get.snackbar('Success', 'Face matched!');
        } else {
          statusMessage.value = 'Face not matched! ❌';
          Get.snackbar('Error', 'Face not matched!');
        }
      } else {
        statusMessage.value = 'Error verifying face: ${response.data}';
        Get.snackbar('Error', 'Error verifying face: ${response.data}');
      }
    } catch (e) {
      statusMessage.value = 'Failed to verify face: $e';
      Get.snackbar('Error', 'Failed to verify face: $e');
      Get.log('Error: Failed to verify face: $e');
    } finally {
      isVerifying.value = false;
    }
  }

  // Get token from SharedPreferences or SecureStorage
  Future<String> _getToken() async {
    // Nếu bạn đã chuyển sang sử dụng flutter_secure_storage, hãy sử dụng như sau:
    /*
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'token') ?? '';
    */

    // Nếu vẫn sử dụng SharedPreferences:
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}

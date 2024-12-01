// import 'dart:io';
// import 'dart:math' as math;
// import 'dart:typed_data';

// import 'package:get/get.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:flutter/foundation.dart';

// import '../repositories/user_repository.dart';

// class FaceAIController extends GetxController {
//   // -------------------------
//   // Camera
//   // -------------------------
//   CameraController? cameraController;
//   RxBool isCameraInitialized = false.obs;
//   RxBool isProcessing = false.obs; // cờ tránh bấm chụp liên tục
//   RxString statusMessage = 'Initializing...'.obs;

//   // -------------------------
//   // MLKit Face Detector
//   // -------------------------
//   final FaceDetector faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableLandmarks: true, // nếu cần
//       enableTracking: false,
//       enableClassification: false,
//       enableContours: false,
//     ),
//   );

//   // -------------------------
//   // TFLite
//   // -------------------------
//   Interpreter? _interpreter;
//   final int inputWidth = 112;
//   final int inputHeight = 112;
//   final int outputDim = 128; // MobileFaceNet embedding size
//   final double mean = 127.5;
//   final double std = 127.5;

//   // -------------------------
//   // API Repository
//   // -------------------------
//   final UserRepository userRepository;

//   // Lưu landmark (nếu cần hiển thị)
//   List<FaceLandmark>? lastLandmarks = [];

//   FaceAIController(this.userRepository);

//   @override
//   Future<void> onInit() async {
//     super.onInit();
//     await _loadModel();
//     await _initCamera();
//   }

//   @override
//   void onClose() {
//     cameraController?.dispose();
//     faceDetector.close();
//     _interpreter?.close();
//     super.onClose();
//   }

//   // ---------------------------------------------------------------------------
//   // 1) Load model TFLite
//   // ---------------------------------------------------------------------------
//   Future<void> _loadModel() async {
//     try {
//       final options = InterpreterOptions()..threads = 1;
//       _interpreter =
//           await Interpreter.fromAsset('mobilefacenet.tflite', options: options);
//       statusMessage.value = 'Model loaded.';
//     } catch (e) {
//       statusMessage.value = 'Error load model: $e';
//       debugPrint('Error load model: $e');
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // 2) Init Camera (front)
//   // ---------------------------------------------------------------------------
//   Future<void> _initCamera() async {
//     try {
//       final cameras = await availableCameras();
//       final frontCamera = cameras.firstWhere(
//         (c) => c.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );

//       cameraController = CameraController(
//         frontCamera,
//         ResolutionPreset.medium,
//         enableAudio: false,
//       );

//       await cameraController!.initialize();
//       isCameraInitialized.value = true;
//       statusMessage.value = 'Camera ready.';
//     } catch (e) {
//       statusMessage.value = 'Error init camera: $e';
//       debugPrint('Error init camera: $e');
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // 3) Hàm chụp + detect + extract + upload
//   //    => Tùy logic, ta gọi "enroll" hoặc "verify"
//   // ---------------------------------------------------------------------------
//   Future<void> captureAndUploadFace({bool enroll = true}) async {
//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       statusMessage.value = 'Camera not ready';
//       return;
//     }
//     if (isProcessing.value) return;

//     isProcessing.value = true;
//     statusMessage.value =
//         enroll ? 'Capturing (enroll)...' : 'Capturing (verify)...';

//     try {
//       // Chụp ảnh
//       final xfile = await cameraController!.takePicture();
//       final bytes = await File(xfile.path).readAsBytes();

//       // Detect & crop
//       final croppedBytes = await _detectAndCropFace(bytes);
//       if (croppedBytes == null) {
//         statusMessage.value = 'No face detected.';
//         return;
//       }

//       // Extract embedding
//       final embedding = _extractEmbedding(croppedBytes);
//       if (embedding == null) {
//         statusMessage.value = 'Extract embedding failed.';
//         return;
//       }

//       // Upload (enroll or verify)
//       await _uploadEmbedding(embedding, enroll: enroll);
//     } catch (e) {
//       final msg = enroll ? 'Enroll error' : 'Verify error';
//       statusMessage.value = '$msg: $e';
//       debugPrint('$msg: $e');
//     } finally {
//       isProcessing.value = false;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // 4) Detect & Crop
//   // ---------------------------------------------------------------------------
//   Future<Uint8List?> _detectAndCropFace(Uint8List imageBytes) async {
//     try {
//       final dir = await getTemporaryDirectory();
//       final tmpPath =
//           '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final tmpFile = File(tmpPath);
//       await tmpFile.writeAsBytes(imageBytes);

//       final inputImage = InputImage.fromFilePath(tmpFile.path);
//       final faces = await faceDetector.processImage(inputImage);

//       if (faces.isEmpty) return null;
//       final face = faces[0];

//       // Lưu landmark (nếu cần hiển thị)
//       lastLandmarks = face.landmarks.values.cast<FaceLandmark>().toList();

//       // Lấy bounding box
//       final box = face.boundingBox;

//       final rawImg = img.decodeImage(imageBytes);
//       if (rawImg == null) {
//         debugPrint('decodeImage => null in detectAndCropFace');
//         return null;
//       }

//       // Crop
//       int x = box.left.floor();
//       int y = box.top.floor();
//       int w = box.width.floor();
//       int h = box.height.floor();

//       // Giới hạn
//       if (x < 0) x = 0;
//       if (y < 0) y = 0;
//       if (x + w > rawImg.width) w = rawImg.width - x;
//       if (y + h > rawImg.height) h = rawImg.height - y;

//       final cropped = img.copyCrop(rawImg, x: x, y: y, width: w, height: h);
//       final resultBytes = Uint8List.fromList(img.encodeJpg(cropped));

//       debugPrint('Cropped size: ${resultBytes.length} bytes');
//       return resultBytes;
//     } catch (ex) {
//       debugPrint('detectAndCropFace error: $ex');
//       return null;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // 5) TFLite: Extract Embedding
//   // ---------------------------------------------------------------------------
//   List<double>? _extractEmbedding(Uint8List croppedBytes) {
//     if (_interpreter == null) {
//       statusMessage.value = 'Interpreter not ready';
//       return null;
//     }

//     final decoded = img.decodeImage(croppedBytes);
//     if (decoded == null) {
//       debugPrint('decodeImage => null in _extractEmbedding');
//       return null;
//     }

//     // Resize
//     final resized =
//         img.copyResize(decoded, width: inputWidth, height: inputHeight);

//     // Tạo input
//     final input = Float32List(inputWidth * inputHeight * 3);
//     int idx = 0;
//     for (int y = 0; y < inputHeight; y++) {
//       for (int x = 0; x < inputWidth; x++) {
//         final pixel = resized.getPixel(x, y);
//         final r = pixel.r;
//         final g = pixel.g;
//         final b = pixel.b;

//         input[idx++] = (r - mean) / std;
//         input[idx++] = (g - mean) / std;
//         input[idx++] = (b - mean) / std;
//       }
//     }

//     // Output
//     final output = List.filled(outputDim, 0.0).reshape([1, outputDim]);
//     _interpreter!.run(input.reshape([1, inputHeight, inputWidth, 3]), output);

//     List<double> embedding = List<double>.from(output[0]);

//     // L2 normalize
//     double sum = 0;
//     for (var e in embedding) sum += e * e;
//     final norm = math.sqrt(sum);
//     if (norm > 0) {
//       embedding = embedding.map((e) => e / norm).toList();
//     }

//     return embedding;
//   }

//   // ---------------------------------------------------------------------------
//   // 6) Upload Embedding (save-face-data or verify-face-data)
//   // ---------------------------------------------------------------------------
//   Future<void> _uploadEmbedding(List<double> embedding,
//       {required bool enroll}) async {
//     statusMessage.value = enroll ? 'Enrolling face...' : 'Verifying face...';

//     try {
//       final token = await userRepository.getToken();

//       final data = {
//         'face_embedding': embedding, // server sẽ json_decode()
//       };

//       late dio.Response resp;
//       if (enroll) {
//         resp = await userRepository.saveFaceEmbedding(token, data);
//       } else {
//         resp = await userRepository.verifyFaceEmbedding(token, data);
//       }

//       if (resp.statusCode == 200) {
//         final body = resp.data;
//         if (enroll) {
//           statusMessage.value = 'Face embedding saved.';
//         } else {
//           if (body['status'] == 'success') {
//             statusMessage.value = 'Matched! distance=${body['distance']}';
//           } else {
//             statusMessage.value = 'Not matched! distance=${body['distance']}';
//           }
//         }
//       } else {
//         statusMessage.value = 'API error: ${resp.data}';
//       }
//     } catch (e) {
//       statusMessage.value = 'Upload error: $e';
//       debugPrint('Upload error: $e');
//     }
//   }
// }

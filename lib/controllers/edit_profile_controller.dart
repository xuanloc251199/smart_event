import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class EditProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxMap<String, String> scannedData = RxMap<String, String>({});

  // Chụp ảnh từ Camera
  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        // await scanImage(selectedImage.value!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
  }

  // Chọn ảnh từ Thư viện
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        // await scanImage(selectedImage.value!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Quét thông tin từ ảnh
  // Future<void> scanImage(File imageFile) async {
  //   final inputImage = InputImage.fromFile(imageFile);
  //   final textDetector = GoogleMlKit.vision.textRecognizer();

  //   try {
  //     final recognizedText = await textDetector.processImage(inputImage);
  //     scannedData.clear(); // Xóa dữ liệu cũ

  //     for (var block in recognizedText.blocks) {
  //       final text = block.text;

  //       if (text.contains(RegExp(r'Name|Full Name', caseSensitive: false))) {
  //         scannedData['full_name'] = text.split(':').last.trim();
  //       } else if (text
  //           .contains(RegExp(r'Date of Birth|DOB', caseSensitive: false))) {
  //         scannedData['date_of_birth'] = text.split(':').last.trim();
  //       } else if (text.contains(RegExp(r'Address', caseSensitive: false))) {
  //         scannedData['address'] = text.split(':').last.trim();
  //       } else if (text
  //           .contains(RegExp(r'Identity Card|ID', caseSensitive: false))) {
  //         scannedData['identity_card'] = text.split(':').last.trim();
  //       } else if (text.contains(RegExp(r'Student ID', caseSensitive: false))) {
  //         scannedData['student_id'] = text.split(':').last.trim();
  //       } else if (text.contains(RegExp(r'University', caseSensitive: false))) {
  //         scannedData['university'] = text.split(':').last.trim();
  //       } else if (text.contains(RegExp(r'Faculty', caseSensitive: false))) {
  //         scannedData['faculty'] = text.split(':').last.trim();
  //       } else if (text.contains(RegExp(r'Class', caseSensitive: false))) {
  //         scannedData['class'] = text.split(':').last.trim();
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to scan image: $e');
  //   } finally {
  //     textDetector.close();
  //   }
  // }

  // Upload dữ liệu lên server
  // Future<void> uploadData() async {
  //   try {
  //     final dioInstance = dio.Dio();
  //     final token = 'your_auth_token_here'; // Lấy token từ SharedPreferences

  //     // Upload thông tin
  //     await dioInstance.put(
  //       'http://your-server-url/user-detail',
  //       data: scannedData,
  //       options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
  //     );

  //     // Upload ảnh
  //     if (selectedImage.value != null) {
  //       final formData = dio.FormData.fromMap({
  //         'image': await dio.MultipartFile.fromFile(
  //           selectedImage.value!.path,
  //           filename: 'profile.jpg',
  //         ),
  //       });

  //       await dioInstance.post(
  //         'http://your-server-url/upload-image',
  //         data: formData,
  //         options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
  //       );
  //     }

  //     Get.snackbar('Success', 'Profile updated successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to upload data: $e');
  //   }
  // }
}

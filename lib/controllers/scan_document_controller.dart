import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanDocumentController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Lưu ảnh và dữ liệu quét
  Rx<File?> selectedImage = Rx<File?>(null);
  RxMap<String, String> scannedData = RxMap<String, String>({});

  // Hàm để chụp ảnh hoặc chọn ảnh từ thư viện
  Future<void> pickImage({bool isCamera = true}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        await processImage(selectedImage.value!); // Xử lý ảnh
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Xử lý ảnh để nhận diện văn bản
  Future<void> processImage(File imageFile) async {
    try {
      // Khởi tạo TextRecognizer
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();

      // Thực hiện OCR
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // Log toàn bộ văn bản OCR (nếu cần kiểm tra)
      print('Recognized Text: ${recognizedText.text}');

      // Phân tích và trích xuất thông tin
      extractData(recognizedText.text);

      // Giải phóng tài nguyên TextRecognizer
      await textRecognizer.close();
    } catch (e) {
      Get.snackbar('Error', 'Failed to process image: $e');
    }
  }

  // Trích xuất thông tin từ văn bản OCR
  void extractData(String text) {
    final idRegex = RegExp(r'Số[:]?\s*(\d{12})'); // Số căn cước công dân
    final nameRegex = RegExp(r'Họ và tên[:]?\s*([\w\sÀ-ỹ]+)');
    final dobRegex = RegExp(r'Ngày sinh[:]?\s*(\d{2}/\d{2}/\d{4})');
    final genderRegex = RegExp(r'Giới tính[:]?\s*(\w+)');
    final pobRegex = RegExp(r'Quê quán[:]?\s*([\w\sÀ-ỹ,]+)');
    final addressRegex = RegExp(r'Nơi thường trú[:]?\s*([\w\sÀ-ỹ,]+)');
    final expiryRegex = RegExp(r'Có giá trị đến[:]?\s*(\d{2}/\d{2}/\d{4})');

    scannedData['id'] = idRegex.firstMatch(text)?.group(1) ?? 'Not Found';
    scannedData['name'] = nameRegex.firstMatch(text)?.group(1) ?? 'Not Found';
    scannedData['dob'] = dobRegex.firstMatch(text)?.group(1) ?? 'Not Found';
    scannedData['gender'] =
        genderRegex.firstMatch(text)?.group(1) ?? 'Not Found';
    scannedData['place_of_birth'] =
        pobRegex.firstMatch(text)?.group(1) ?? 'Not Found';
    scannedData['address'] =
        addressRegex.firstMatch(text)?.group(1) ?? 'Not Found';
    scannedData['expiry_date'] =
        expiryRegex.firstMatch(text)?.group(1) ?? 'Not Found';
  }

  // Hàm để reset dữ liệu quét
  void resetData() {
    selectedImage.value = null;
    scannedData.clear();
  }
}

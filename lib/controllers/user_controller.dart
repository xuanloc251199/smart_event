import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/views/screens/face_scan_screen.dart';

class UserController extends GetxController {
  final UserRepository userRepository = Get.find<UserRepository>();

  RxBool isLoading = false.obs;
  RxMap<String, dynamic> userData = RxMap<String, dynamic>({});
  RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> faculties = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredClasses = <Map<String, dynamic>>[].obs;

  RxString selectedClassId = ''.obs;
  RxString selectedFacultyId = ''.obs;

  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedAvatar = Rx<File?>(null); // Avatar được chọn
  Rx<File?> scannedFaceImage = Rx<File?>(null); // Hình ảnh quét được

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchUserDetails() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? prefs.getString('temp_token');

      if (token != null) {
        final response = await userRepository.getProfile(token);

        print(
            'API Response profile screen: ${response.data}'); // Debug API response

        if (response.statusCode == 200) {
          final data = response.data['data'];

          userData.value = {
            'id': data['user_id'] ?? 'N/A',
            'username': data['username'] ?? 'N/A', // Gán giá trị mặc định
            'email': data['email'] ?? 'N/A',
            'full_name': data['full_name'] ?? data['email'] ?? 'N/A',
            'sex': data['sex'] ?? 'N/A',
            'phone': data['phone'] ?? 'N/A',
            'date_of_birth': data['date_of_birth'] ?? 'N/A',
            'address': data['address'] ?? 'N/A',
            'permanent_address': data['permanent_address'] ?? 'N/A',
            'avatar': data['avatar'] ?? AppIcons.logo_app,
            'face_data': data['face_data'] ?? '',
            'identity_card': data['identity_card'] ?? 'N/A',
            'student_id': data['student_id'] ?? 'N/A',
            'university': data['unit']?['abbreviation'] ?? 'N/A',
            'faculty': data['faculty'] ?? 'N/A',
            'class': data['class'] ?? 'N/A',
          };

          // Debug userData
          print('userData: $userData');
        } else {
          Get.log('Error: Failed to fetch user details.');
        }
      } else {
        Get.log('Error: No token found.');
      }
    } catch (e) {
      Get.log('Error: Failed to fetch user details: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateUserDetails({
    required String fullName,
    required String sex,
    required String phone,
    required String dob,
    required String address,
    required String permanentAddress,
    required String identityCard,
    required String studentId,
    required int? selectedUnitId,
    required int? selectedFacultyId,
    required int? selectedClassId,
  }) async {
    isLoading(true);
    try {
      // Tạo dữ liệu JSON cơ bản
      final Map<String, dynamic> updatedData = {
        'full_name': fullName,
        'sex': sex,
        'phone': phone,
        'date_of_birth': dob.isNotEmpty
            ? dob.split('-').reversed.join('-') // Chuyển d-m-Y -> Y-m-d
            : null,
        'address': address,
        'permanent_address': permanentAddress,
        'identity_card': identityCard,
        'student_id': studentId,
        'unit_id': selectedUnitId,
        'faculty_id': selectedFacultyId,
        'class_id': selectedClassId,
      };

      // Tạo FormData để gửi file avatar
      final formData = dio.FormData.fromMap(updatedData);

      if (selectedAvatar.value != null) {
        // Thêm avatar mới vào FormData nếu được chọn
        formData.files.add(
          MapEntry(
            'avatar',
            await dio.MultipartFile.fromFile(
              selectedAvatar.value!.path,
              filename: selectedAvatar.value!.path.split('/').last,
            ),
          ),
        );
      } else if (userData['avatar'] != null && userData['avatar'].isNotEmpty) {
        // Thêm avatar cũ nếu không có avatar mới
        formData.fields.add(
          MapEntry('avatar', userData['avatar']),
        );
      }

      // Gửi yêu cầu cập nhật
      final response = await userRepository.updateProfile(formData);

      if (response.statusCode == 200) {
        // Cập nhật userData từ dữ liệu trả về
        final data = response.data['data'];
        userData.value = {
          'username': userData['username'] ?? '', // Giữ nguyên username
          'email': userData['email'] ?? '', // Giữ nguyên email
          'full_name': data['full_name'] ?? '',
          'sex': data['sex'] ?? '',
          'phone': data['phone'] ?? '',
          'date_of_birth': data['date_of_birth'] ?? '',
          'address': data['address'] ?? '',
          'permanent_address': data['permanent_address'] ?? '',
          'avatar': data['avatar'] ?? userData['avatar'], // Avatar mới hoặc cũ
          'identity_card': data['identity_card'] ?? '',
          'student_id': data['student_id'] ?? '',
          'university': data['unit']?['abbreviation'] ?? '',
          'faculty': data['faculty'] ?? '',
          'class': data['class'] ?? '',
        };

        Get.snackbar('Success', 'Profile updated successfully.');
      } else {
        // Log lỗi nếu có
        Get.log('Error: ${response.data}');
        Get.snackbar(
            'Error', 'Failed to update profile: ${response.data['message']}');
      }
    } catch (e) {
      // Bắt lỗi và log thông tin chi tiết
      if (e is dio.DioException) {
        Get.log('Dio Error: ${e.response?.data}');
        Get.snackbar('Error', 'Failed to update profile: ${e.response?.data}');
      } else {
        Get.log('Error: $e');
        Get.snackbar('Error', 'Failed to update profile: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedAvatar.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        selectedAvatar.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
  }
}

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/views/screens/face_scan_screen.dart';

class UserController extends GetxController {
  final UserRepository userRepository;

  UserController(this.userRepository);

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
    fetchFacultiesAndClasses();
  }

  Future<void> fetchUserDetails() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? prefs.getString('temp_token');

      if (token != null) {
        final response = await userRepository.getProfile(token);

        print('API Response: ${response.data}'); // Debug API response

        if (response.statusCode == 200) {
          final data = response.data['data'];

          userData.value = {
            'username': data['username'] ?? '', // Gán username
            'email': data['email'] ?? '', // Gán email
            'full_name': data['full_name'] ?? '',
            'sex': data['sex'] ?? '',
            'phone': data['phone'] ?? '',
            'date_of_birth': data['date_of_birth'] ?? '',
            'address': data['address'] ?? '',
            'permanent_address': data['permanent_address'] ?? '',
            'avatar': data['avatar'] ?? AppImage.imgAvatarDefault,
            'face_data': data['face_data'] ?? AppImage.imgAvatarDefault,
            'identity_card': data['identity_card'] ?? '',
            'student_id': data['student_id'] ?? '',
            'university': data['university'] ?? '',
            'faculty': data['faculty'] ?? '',
            'class': data['class'] ?? '',
          };

          // Debug userData
          print('userData: $userData');
        } else {
          Get.snackbar('Error', 'Failed to fetch user details.');
        }
      } else {
        Get.snackbar('Error', 'No token found.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user details: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchFacultiesAndClasses() async {
    try {
      isLoading(true);

      final facultiesData = await userRepository.getFaculties();
      final classesData = await userRepository.getClasses();

      faculties.value = facultiesData.map((faculty) {
        return {
          'id': faculty['id'],
          'faculty': faculty['faculty'],
        };
      }).toList();

      classes.value = classesData.map((classItem) {
        return {
          'id': classItem['id'],
          'class_name': classItem['class_name'],
          'faculty_id':
              classItem['faculty_id'], // Đảm bảo faculty_id có trong class
        };
      }).toList();

      // Thiết lập giá trị mặc định
      if (faculties.isNotEmpty) {
        selectedFacultyId.value = faculties.first['id'].toString();
        filterClassesByFaculty(selectedFacultyId.value);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch faculties or classes: $e');
    } finally {
      isLoading(false);
    }
  }

  void filterClassesByFaculty(String facultyId) {
    filteredClasses.value = classes
        .where((classItem) => classItem['faculty_id'].toString() == facultyId)
        .toList();

    // Đặt giá trị mặc định cho class nếu thay đổi faculty
    if (filteredClasses.isNotEmpty) {
      selectedClassId.value = filteredClasses.first['id'].toString();
    } else {
      selectedClassId.value = '';
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
    required String university,
    required String selectedFacultyId,
    required String selectedClassId,
  }) async {
    isLoading(true);
    try {
      final updatedData = {
        'full_name': fullName.isNotEmpty ? fullName : null,
        'sex': sex.isNotEmpty ? sex : null,
        'phone': phone.isNotEmpty ? phone : null,
        'date_of_birth': dob.isNotEmpty
            ? dob.split('-').reversed.join('-') // Chuyển d-m-Y -> Y-m-d
            : null,
        'address': address.isNotEmpty ? address : null,
        'permanent_address':
            permanentAddress.isNotEmpty ? permanentAddress : null,
        'identity_card': identityCard.isNotEmpty ? identityCard : null,
        'student_id': studentId.isNotEmpty ? studentId : null,
        'university': university.isNotEmpty ? university : null,
        'faculty_id': selectedFacultyId.isNotEmpty ? selectedFacultyId : null,
        'class_id': selectedClassId.isNotEmpty ? selectedClassId : null,
      };

      final response = await userRepository.updateProfile(updatedData);

      if (response.statusCode == 200) {
        userData.value = response.data['data'];
        userData['email'] = userData['email'];
        Get.snackbar('Success', 'Profile updated successfully.');
      } else {
        Get.snackbar(
            'Error', 'Failed to update profile: ${response.data['message']}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> pickAvatar() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedAvatar.value = File(image.path);
    }
  }

  Future<void> updateProfileWithAvatar({
    required String fullName,
    required String sex,
    required String phone,
    required String dob,
    required String address,
    required String permanentAddress,
    required String identityCard,
    required String studentId,
    required String university,
    required String selectedFacultyId,
    required String selectedClassId,
  }) async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found');
      }

      // 1. Update user details
      final updatedData = {
        'full_name': fullName.isNotEmpty ? fullName : null,
        'sex': sex.isNotEmpty ? sex : null,
        'phone': phone.isNotEmpty ? phone : null,
        'date_of_birth': dob.isNotEmpty
            ? dob.split('-').reversed.join('-') // Convert d-m-Y to Y-m-d
            : null,
        'address': address.isNotEmpty ? address : null,
        'permanent_address':
            permanentAddress.isNotEmpty ? permanentAddress : null,
        'identity_card': identityCard.isNotEmpty ? identityCard : null,
        'student_id': studentId.isNotEmpty ? studentId : null,
        'university': university.isNotEmpty ? university : null,
        'faculty_id': selectedFacultyId.isNotEmpty ? selectedFacultyId : null,
        'class_id': selectedClassId.isNotEmpty ? selectedClassId : null,
      };

      final userResponse = await userRepository.updateProfile(updatedData);

      if (userResponse.statusCode == 200) {
        userData.value = userResponse.data['data'];
        Get.snackbar('Success', 'Profile updated successfully.');

        // 2. Upload avatar if selected
        if (selectedAvatar.value != null) {
          final formData = dio.FormData.fromMap({
            'avatar': await dio.MultipartFile.fromFile(
              selectedAvatar.value!.path,
              filename: selectedAvatar.value!.path.split('/').last,
            ),
          });

          final avatarResponse =
              await userRepository.updateAvatar(token, formData);

          if (avatarResponse.statusCode == 200) {
            userData['avatar'] = avatarResponse.data['avatar'];
            Get.snackbar('Success', 'Avatar updated successfully.');
          } else {
            throw Exception('Failed to update avatar: ${avatarResponse.data}');
          }
        }
      } else {
        throw Exception(
            'Failed to update profile: ${userResponse.data['message']}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile or avatar: $e');
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

  // Future<void> scanFace() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

  //     if (pickedFile != null) {
  //       final faceDetector = FaceDetector(
  //         options: FaceDetectorOptions(
  //           enableContours: true, // Kích hoạt phát hiện các đường nét khuôn mặt
  //           enableClassification: true, // Kích hoạt nhận dạng biểu cảm
  //         ),
  //       );

  //       final inputImage = InputImage.fromFile(File(pickedFile.path));
  //       final faces = await faceDetector.processImage(inputImage);

  //       if (faces.isNotEmpty) {
  //         scannedFaceImage.value = File(pickedFile.path);
  //         Get.snackbar('Success', 'Face detected successfully.');
  //       } else {
  //         Get.snackbar('Error', 'No face detected. Please try again.');
  //       }

  //       faceDetector.close(); // Đóng face detector để giải phóng tài nguyên
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to detect face: $e');
  //   }
  // }

  Future<void> uploadFaceData() async {
    if (scannedFaceImage.value != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');

        if (token == null) {
          throw Exception('No token found');
        }

        final formData = dio.FormData.fromMap({
          'face_image': await dio.MultipartFile.fromFile(
            scannedFaceImage.value!.path,
            filename: scannedFaceImage.value!.path.split('/').last,
          ),
        });

        final response = await userRepository.saveFaceData(token, formData);

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Face data uploaded successfully.');
        } else {
          Get.snackbar('Error', 'Failed to upload face data.');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload face data: $e');
      }
    } else {
      Get.snackbar('Error', 'No face image to upload.');
    }
  }

  Future<void> scanAndUploadFace() async {
    try {
      // Mở màn hình quét khuôn mặt và lấy đường dẫn ảnh
      final imagePath = await Get.to(() => FaceScanScreen());
      if (imagePath == null) {
        Get.snackbar('Thông báo', 'Quét khuôn mặt đã bị hủy.');
        return;
      }

      // Hiển thị trạng thái tải lên
      isLoading(true);

      // Kiểm tra token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception("Không tìm thấy token. Vui lòng đăng nhập lại.");
      }

      // Chuẩn bị dữ liệu tải lên
      final formData = dio.FormData.fromMap({
        'face_image': await dio.MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      // Gọi API để tải lên dữ liệu khuôn mặt
      final response = await userRepository.uploadFaceData(token, formData);

      // Kiểm tra phản hồi từ server
      if (response.statusCode == 200) {
        Get.snackbar('Thành công', 'Khuôn mặt đã được lưu thành công.');
      } else {
        Get.snackbar(
          'Lỗi',
          'Không thể lưu khuôn mặt: ${response.data['message'] ?? 'Lỗi không xác định'}',
        );
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể quét hoặc upload khuôn mặt: $e');
    } finally {
      isLoading(false); // Ẩn trạng thái tải lên
    }
  }
}

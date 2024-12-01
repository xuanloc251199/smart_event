import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/routes/app_route.dart';
import 'package:smart_event/controllers/user_controller.dart';

class SignInController extends GetxController {
  final UserRepository userRepository = Get.find<UserRepository>();

  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> toggleRememberMe(bool value) async {
    rememberMe.value = value; // Cập nhật trạng thái Remember Me
  }

  Future<void> signin(String email, String password) async {
    isLoading(true);
    try {
      final response = await userRepository.login({
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responseData = response.data;
        final token = responseData['access_token'];

        final prefs = await SharedPreferences.getInstance();
        if (rememberMe.value) {
          await prefs.setString('token', token); // Lưu token
        } else {
          await prefs.setString('temp_token', token); // Lưu token tạm
        }

        final userController = Get.find<UserController>();
        await userController.fetchUserDetails();

        Get.offNamed(AppRoutes.base); // Chuyển đến màn hình chính
      } else {
        Get.snackbar(
            'Login Failed', response.data['message'] ?? 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      Get.log('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? prefs.getString('temp_token');

      if (token != null) {
        // Gửi yêu cầu logout đến server
        final response = await userRepository.logout(token);

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Logged out successfully.');
        } else {
          Get.snackbar('Error', response.data['message'] ?? 'Logout failed.');
        }
      }

      // Xóa toàn bộ dữ liệu lưu trữ
      await prefs.clear();
      Get.offAllNamed(AppRoutes.signIn); // Chuyển về màn hình đăng nhập
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out: $e');
    } finally {
      isLoading(false);
    }
  }
}

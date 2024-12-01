import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/routes/app_route.dart';
import 'package:smart_event/controllers/user_controller.dart';

class SignInController extends GetxController {
  final UserRepository userRepository;

  SignInController(this.userRepository);

  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập khi khởi tạo
  }

  Future<void> toggleRememberMe(bool value) async {
    rememberMe.value = value; // Cập nhật trạng thái Remember Me
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final tempToken = prefs.getString('temp_token');

    if (token != null) {
      // Nếu có token lưu (Remember Me), chuyển đến màn hình chính
      final userController = Get.find<UserController>();
      await userController.fetchUserDetails();
      Get.offNamed(AppRoutes.base);
    } else if (tempToken != null) {
      // Nếu có temp_token (Không Remember Me), xóa temp_token và trả về màn hình đăng nhập
      await prefs.remove('temp_token');
      Get.offAllNamed(AppRoutes.signIn);
    } else {
      // Không có thông tin đăng nhập, trả về màn hình đăng nhập
      Get.offAllNamed(AppRoutes.signIn);
    }
  }

  Future<void> signin(String email, String password) async {
    isLoading(true);
    try {
      final response =
          await userRepository.login({'email': email, 'password': password});

      if (response.statusCode == 200) {
        final responseData = response.data;
        final token = responseData['access_token'];

        final prefs = await SharedPreferences.getInstance();
        if (rememberMe.value) {
          await prefs.setString('token', token); // Lưu token nếu Remember Me
        } else {
          await prefs.setString('temp_token', token); // Lưu temp_token
        }

        final userController = Get.find<UserController>();
        await userController.fetchUserDetails();

        Get.offNamed(AppRoutes.base); // Chuyển đến màn hình chính
      } else {
        Get.snackbar(
          'Login Failed',
          response.data['message'] ?? 'Invalid credentials',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
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
        await userRepository.logout(token);
      }

      await prefs.clear(); // Xóa thông tin đăng nhập
      Get.offAllNamed(AppRoutes.signIn); // Chuyển về màn hình đăng nhập
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out: $e');
    } finally {
      isLoading(false);
    }
  }
}

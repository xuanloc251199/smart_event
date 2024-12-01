import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/routes/app_route.dart';

class SignOutController extends GetxController {
  final UserRepository userRepository = Get.find<UserRepository>();

  RxBool isLoading = false.obs;

  Future<void> signOut() async {
    isLoading(true);
    try {
      // Lấy token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        // Gọi API logout
        await userRepository.logout(token);
      }

      // Xóa token và các thông tin liên quan
      await prefs.clear();

      // Điều hướng về màn hình đăng nhập
      Get.offAllNamed(AppRoutes.signIn);
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out. Please try again.');
    } finally {
      isLoading(false);
    }
  }
}

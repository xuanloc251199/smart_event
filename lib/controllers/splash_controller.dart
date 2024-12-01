import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/routes/app_route.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus(); // Kiểm tra trạng thái đăng nhập khi khởi chạy
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(
        Duration(seconds: 3)); // Thời gian chờ cho màn hình splash

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final tempToken = prefs.getString('temp_token');

    if (token != null) {
      // Nếu có token, người dùng đã chọn "Remember Me"
      try {
        final userController = Get.find<UserController>();
        await userController.fetchUserDetails();
        Get.offNamed(AppRoutes.base); // Chuyển đến màn hình chính
      } catch (e) {
        // Nếu lỗi khi lấy thông tin, đưa người dùng về màn hình đăng nhập
        Get.offNamed(AppRoutes.signIn);
      }
    } else if (tempToken != null) {
      // Nếu có tempToken, người dùng không chọn "Remember Me"
      await prefs.remove('temp_token'); // Xóa tempToken
      Get.offNamed(AppRoutes.signIn); // Điều hướng đến màn hình đăng nhập
    } else {
      // Không có token hoặc tempToken
      Get.offNamed(AppRoutes.signIn);
    }
  }
}

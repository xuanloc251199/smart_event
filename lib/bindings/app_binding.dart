import 'package:get/get.dart';
import 'package:smart_event/controllers/sign_in_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/services/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService()); // Khởi tạo ApiService
    Get.lazyPut(() =>
        UserRepository(Get.find())); // Khởi tạo UserRepository với ApiService
    Get.lazyPut(() => SignInController(
        Get.find())); // Khởi tạo SignInController với UserRepository
  }
}

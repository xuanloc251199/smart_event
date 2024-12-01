import 'package:get/get.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}

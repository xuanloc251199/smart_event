import 'package:get/get.dart';
import 'package:smart_event/controllers/bottom_nav_controller.dart';
import 'package:smart_event/controllers/calendar_controller.dart';
import 'package:smart_event/controllers/category_controller.dart';
import 'package:smart_event/controllers/edit_profile_controller.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/controllers/face_scan_controller.dart';
import 'package:smart_event/controllers/face_verify_controller.dart';
import 'package:smart_event/controllers/profile_controller.dart';
import 'package:smart_event/controllers/qr_scan_controller.dart';
import 'package:smart_event/controllers/side_bar_controller.dart';
import 'package:smart_event/controllers/sign_in_controller.dart';
import 'package:smart_event/controllers/sign_out_controller.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/repositories/category_repository.dart';
import 'package:smart_event/repositories/class_repository.dart';
import 'package:smart_event/repositories/event_repository.dart';
import 'package:smart_event/repositories/faculty_repository.dart';
import 'package:smart_event/repositories/profile_repository.dart';
import 'package:smart_event/repositories/unit_reponsitory.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/services/api_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Khởi tạo ApiService
    final apiService = ApiService();

    // Đăng ký các service và repository với Get.lazyPut
    Get.lazyPut(() => apiService);
    Get.lazyPut(() => UserRepository(Get.find<ApiService>()));
    Get.lazyPut(() => ProfileRepository(Get.find<ApiService>()));
    Get.lazyPut(() => EventRepository(Get.find<ApiService>()));
    Get.lazyPut(() => UnitRepository(Get.find<ApiService>()));
    Get.lazyPut(() => ClassRepository(Get.find<ApiService>()));
    Get.lazyPut(() => FacultyRepository(Get.find<ApiService>()));
    Get.lazyPut(() => CategoryRepository(Get.find<ApiService>()));

    Get.lazyPut(() => SidebarController());
    Get.lazyPut(() => BottomNavController());
    Get.lazyPut(() => CalendarController());
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => EditProfileController());
    Get.lazyPut(() => EventController());
    Get.lazyPut(() => FaceScanController());
    Get.lazyPut(() => FaceVerifyController());
    Get.lazyPut(() => QrScanController());
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => SignOutController());
    Get.put(UserController(), permanent: true);
  }
}

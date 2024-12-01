import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/bindings/app_binding.dart';
import 'package:smart_event/controllers/qr_scan_controller.dart';
import 'package:smart_event/controllers/sign_in_controller.dart';
import 'package:smart_event/controllers/user_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/routes/app_route.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_event/services/api_service.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Làm cho thanh trạng thái trong suốt
      statusBarIconBrightness: Brightness.dark, // Biểu tượng màu tối
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final userRepository = UserRepository(apiService);

  Get.put(UserController(userRepository));
  Get.put(SignInController(userRepository));
  Get.put(QrScanController());

  await initializeDateFormatting('vi', null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => UserRepository(Get.find<ApiService>()));
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Event',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.backgroundWhiteColor,
            appBarTheme: AppBarTheme(
              color: AppColors.backgroundWhiteColor,
            ),
          ),
          initialBinding: AppBinding(),
          initialRoute: AppRoutes.splash,
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}

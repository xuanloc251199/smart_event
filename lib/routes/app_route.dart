import 'package:get/get.dart';
import 'package:smart_event/bindings/app_binding.dart';
import 'package:smart_event/bindings/user_binding.dart';
import 'package:smart_event/views/screens/base_screen.dart';
import 'package:smart_event/views/screens/profile_screen.dart';
import 'package:smart_event/views/screens/sign_in_screen.dart';
import 'package:smart_event/views/screens/sign_up_screen.dart';
import 'package:smart_event/views/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String base = '/base';
  static const String navBar = '/customNavBar';

  static const String profile = '/profile';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: signIn,
      page: () => SignInScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: signUp,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: base,
      page: () => BaseScreen(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      binding: UserBinding(),
    ),
  ];
}

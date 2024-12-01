import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/controllers/splash_controller.dart';
import 'package:smart_event/resources/colors.dart';
import '../../resources/icons.dart';

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhiteColor,
      body: Center(
        child: Image.asset(AppIcons.logo_app),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/views/screens/home/home_screen.dart';

class VerificationController extends GetxController {
  // Các biến
  final verificationCode = "1234";
  final resendCounter = 20.obs; // Đếm ngược thời gian
  final errorMessage = RxnString(); // Thông báo lỗi (nullable)
  final controllers = List.generate(4, (_) => TextEditingController());
  final focusNodes = List.generate(4, (_) => FocusNode());

  // Bắt đầu đếm ngược
  void startResendCounter() {
    if (resendCounter.value > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        resendCounter.value--;
        if (resendCounter.value > 0) {
          startResendCounter();
        }
      });
    }
  }

  // Kiểm tra mã OTP khi nhập
  void onCodeEntered(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  // Xác nhận mã OTP
  void onSubmit() {
    String enteredCode = controllers.map((e) => e.text).join();
    if (enteredCode == verificationCode) {
      errorMessage.value = null;
      Get.snackbar(
        AppString.verifySuccessTitle,
        AppString.verifySuccessNotify,
        backgroundColor: AppColors.greenColor,
        colorText: Colors.white,
      );
      Get.to(() => HomeScreen());
    } else {
      errorMessage.value = AppString.verifyErrorNotify;
      // Get.snackbar(
      //   AppString.verifyErrorTitle,
      //   AppString.verifyErrorNotify,
      //   backgroundColor: AppColors.redColor,
      //   colorText: Colors.white,
      // );
    }
  }

  // Gửi lại mã OTP
  void resendCode() {
    if (resendCounter.value == 0) {
      resendCounter.value = 20;
      errorMessage.value = null;
      startResendCounter();
      Get.snackbar(
        '',
        AppString.resendNotify,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
      );
    }
  }
}

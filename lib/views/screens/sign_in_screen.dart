import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:smart_event/controllers/sign_in_controller.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/utils/validation.dart';
import 'package:smart_event/views/widgets/custom_social_button.dart';
import 'package:smart_event/views/widgets/custom_toggle.dart';
import 'package:smart_event/views/screens/resset_password_screen.dart';
import 'package:smart_event/views/screens/sign_up_screen.dart';

import '../../styles/_text_header_style.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field_widget.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInController controller = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhiteColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpace.spaceMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image.asset(
                      AppIcons.logo_shape,
                      height: 15.h,
                    ),
                  ),
                  SizedBox(
                    height: AppSpace.spaceMedium,
                  ),
                  Text(
                    AppString.signIn,
                    textAlign: TextAlign.start,
                    style: AppTextStyle.textH5Style,
                  ),
                  SizedBox(
                    height: AppSpace.spaceMedium,
                  ),
                  Obx(() {
                    return CustomTextFieldWidget(
                      hintText: AppString.emailHint,
                      prefixImage: AppIcons.ic_mail,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      errorText:
                          emailError.value.isEmpty ? null : emailError.value,
                    );
                  }),
                  SizedBox(
                    height: AppSpace.spaceInputForm,
                  ),
                  Obx(() {
                    return CustomTextFieldWidget(
                      hintText: AppString.passwordHint,
                      prefixImage: AppIcons.ic_lock,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: true,
                      errorText: passwordError.value.isEmpty
                          ? null
                          : passwordError.value,
                    );
                  }),
                  SizedBox(
                    height: AppSpace.spaceMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomToggleButton(
                            initialValue: false,
                            onChanged: (value) {
                              controller.toggleRememberMe(value);
                            },
                          ),
                          SizedBox(
                            width: AppSpace.spaceSmallW,
                          ),
                          Text(
                            AppString.remember,
                            style: AppTextStyle.textMainStyle,
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Text(
                          AppString.forgotPass,
                          style: AppTextStyle.textMainStyle,
                        ),
                        onTap: () => Get.to(RessetPasswordScreen()),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppSpace.spaceMain,
                  ),
                  Obx(() {
                    return controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : CustomButton(
                            text: AppString.signIn.toUpperCase(),
                            onPressed: () {
                              // Kiểm tra tất cả lỗi khi nhấn nút Sign In
                              emailError.value = AppValidator.validateEmail(
                                      emailController.text) ??
                                  '';
                              passwordError.value =
                                  AppValidator.validatePassword(
                                          passwordController.text) ??
                                      '';

                              if (emailError.value.isEmpty &&
                                  passwordError.value.isEmpty) {
                                // Gọi hàm login từ controller nếu không có lỗi
                                controller.signin(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              }
                            },
                          );
                  }),
                  SizedBox(
                    height: AppSpace.spaceMain,
                  ),
                  Center(
                    child: Text(
                      AppString.or.toUpperCase(),
                      style: AppTextStyle.textTitle2Style,
                    ),
                  ),
                  SizedBox(
                    height: AppSpace.spaceMain,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomSocialButton(
                      text: AppString.loginGG,
                      iconPath: AppIcons.ic_google,
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      elevation: 3.0,
                    ),
                  ),
                  SizedBox(
                    height: AppSpace.spaceMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomSocialButton(
                      text: AppString.loginFB,
                      iconPath: AppIcons.ic_facebook,
                      onPressed: () {},
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      elevation: 3.0,
                    ),
                  ),
                  SizedBox(
                    height: AppSpace.spaceMain,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppString.dontHaveAcc,
                        style: AppTextStyle.textBody2Style,
                      ),
                      SizedBox(
                        width: AppSpace.spaceSmallW,
                      ),
                      GestureDetector(
                        onTap: () => Get.to(SignUpScreen()),
                        child: Text(
                          AppString.signUp,
                          style: AppTextStyle.textHighlightTitle,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

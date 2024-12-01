import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/views/widgets/custom_social_button.dart';
import 'package:smart_event/views/screens/sign_in_screen.dart';
import 'package:smart_event/views/screens/verification_screen.dart';

import '../../styles/_text_header_style.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field_widget.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpace.paddingMain),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back),
                    onTap: () => Get.back(),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    AppString.signUp,
                    textAlign: TextAlign.start,
                    style: AppTextStyle.textH5Style,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextFieldWidget(
                    hintText: AppString.fullName,
                    prefixImage: AppIcons.ic_profile,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: AppSpace.spaceInputForm,
                  ),
                  CustomTextFieldWidget(
                    hintText: AppString.emailHint,
                    prefixImage: AppIcons.ic_mail,
                    keyboardType: TextInputType.visiblePassword,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: AppSpace.spaceInputForm,
                  ),
                  CustomTextFieldWidget(
                    hintText: AppString.passwordHint,
                    prefixImage: AppIcons.ic_lock,
                    suffixImage: AppIcons.ic_hiden,
                    keyboardType: TextInputType.visiblePassword,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: AppSpace.spaceInputForm,
                  ),
                  CustomTextFieldWidget(
                    hintText: AppString.confirmPassword,
                    prefixImage: AppIcons.ic_lock,
                    suffixImage: AppIcons.ic_hiden,
                    keyboardType: TextInputType.visiblePassword,
                    controller: emailController,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(
                    height: AppSpace.spaceMain,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: AppString.signUp.toUpperCase(),
                      onPressed: () {
                        Get.to(VerificationScreen());
                      },
                    ),
                  ),
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
                    height: 2.h,
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
                        style: AppTextStyle.textButtonStyle,
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      GestureDetector(
                        onTap: () => Get.to(SignInScreen()),
                        child: Text(
                          AppString.signIn,
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

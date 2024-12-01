import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/views/screens/sign_in_screen.dart';

import '../../styles/_text_header_style.dart';
import '../widgets/custom_text_field_widget.dart';

class RessetPasswordScreen extends StatelessWidget {
  RessetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppSpace.paddingMain),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () => Get.back(),
                ),
                SizedBox(
                  height: AppSpace.spaceMedium,
                ),
                Text(
                  AppString.resetPassword,
                  style: AppTextStyle.textH5Style,
                ),
                SizedBox(
                  height: AppSpace.spaceMedium,
                ),
                Text(
                  AppString.resetPasswordSubTitle,
                  style: AppTextStyle.textBody1Style,
                ),
                SizedBox(
                  height: AppSpace.spaceMain,
                ),
                CustomTextFieldWidget(
                  prefixImage: AppIcons.ic_mail,
                  hintText: AppString.emailHint,
                ),
                SizedBox(
                  height: AppSpace.spaceMain,
                ),
                CustomButton(
                  onPressed: () => Get.to(SignInScreen()),
                  text: AppString.continue_s,
                ),
                SizedBox(
                  height: AppSpace.spaceMain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

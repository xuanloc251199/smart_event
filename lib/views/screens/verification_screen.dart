import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/verification_controller.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/sizes.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/views/widgets/custom_button.dart';

import '../../styles/_text_header_style.dart';

class VerificationScreen extends StatelessWidget {
  final VerificationController controller = Get.put(VerificationController());

  VerificationScreen({Key? key}) : super(key: key);

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
                SizedBox(height: AppSpace.spaceMedium),
                Text(AppString.verification, style: AppTextStyle.textH5Style),
                SizedBox(height: AppSpace.spaceMedium),
                Text(
                  "We’ve sent you the verification code on +1 2620 0323 7631",
                  style: AppTextStyle.textBody1Style,
                ),
                SizedBox(height: AppSpace.spaceMain),
                // Input OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 60.px,
                      height: 60.px,
                      child: TextField(
                        controller: controller.controllers[index],
                        focusNode: controller.focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: AppTextStyle.textButtonStyle,
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.brMain),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.brMain),
                            borderSide:
                                const BorderSide(color: AppColors.primaryColor),
                          ),
                        ),
                        onChanged: (value) =>
                            controller.onCodeEntered(index, value),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: AppSpace.spaceMain),
                CustomButton(
                  onPressed: () => controller.onSubmit(),
                  text: AppString.continue_s,
                ),
                SizedBox(height: 10),
                Obx(() {
                  if (controller.errorMessage.value != null) {
                    return Text(
                      controller.errorMessage.value!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                SizedBox(height: AppSpace.spaceMedium),
                // Resend code
                Center(
                  child: GestureDetector(
                    onTap: () => controller.resendCode(),
                    child: Obx(
                      () => RichText(
                        text: TextSpan(
                          text: AppString.resendCode,
                          style: AppTextStyle.textBody1Style,
                          children: [
                            TextSpan(
                              text: controller.resendCounter.value > 0
                                  ? "0:${controller.resendCounter.value.toString().padLeft(2, '0')}"
                                  : AppString.resend,
                              style: AppTextStyle.textHighlightTitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

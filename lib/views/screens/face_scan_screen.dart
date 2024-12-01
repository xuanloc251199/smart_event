import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/face_scan_controller.dart';
import 'package:smart_event/repositories/user_repository.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/styles/_text_header_style.dart';
import 'package:smart_event/views/layouts/custom_header.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/views/widgets/custom_overlay_painter.dart';

class FaceScanScreen extends StatelessWidget {
  final FaceScanController controller =
      Get.put(FaceScanController(Get.find<UserRepository>()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhiteColor,
      body: Obx(() {
        if (!controller.isCameraInitialized.value) {
          return Center(child: CircularProgressIndicator());
        }
        return SafeArea(
          child: Stack(
            children: [
              // Camera Preview with Transformation for Front Camera
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateY(controller.isFrontCamera ? 3.14159 : 0),
                child: CameraPreview(controller.cameraController!),
              ),

              // Overlay Background with Circular Cutout
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: FaceScanOverlayPainter(
                  circleCenter: Offset(
                    50.w,
                    33.3.h,
                  ),
                  circleRadius: 40.w,
                  overlayColor: AppColors.whiteColor,
                  circleColor: AppColors.primaryColor,
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 100.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpace.spaceSmall,
                    vertical: AppSpace.paddingMain,
                  ),
                  child: CustomHeader(
                    isPreFixIcon: true,
                    prefixIconImage: AppIcons.ic_back,
                    prefixOnTap: Get.back,
                    isSuFixIcon: false,
                    headerTitle: AppString.labelFaceScan,
                    textStyle: AppTextStyle.textTitle1Style,
                  ),
                ),
              ),
              // Status Message
              Positioned(
                bottom: 120,
                left: 0,
                right: 0,
                child: Obx(() {
                  return Text(
                    controller.statusMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  );
                }),
              ),

              // Capture Button
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpace.spaceMain),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () {
                          return controller.isUploading.value
                              ? Container(
                                  width: 50.w - AppSpace.spaceMedium * 3,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                      color: AppColors.primaryColor),
                                )
                              : CustomButton(
                                  width: 50.w - AppSpace.spaceMedium * 3,
                                  text: AppString.capture,
                                  onPressed: () async {
                                    await controller.captureAndUploadFace();
                                  },
                                );
                        },
                      ),
                      CustomButton(
                        isFill: false,
                        width: 50.w - AppSpace.spaceMedium * 3,
                        text: AppString.cancel,
                        textStyle: AppTextStyle.textButtonHighlightStyle,
                        onPressed: () => Get.back(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

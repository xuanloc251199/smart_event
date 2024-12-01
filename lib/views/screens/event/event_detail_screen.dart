import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/helpers/button_status.dart';
import 'package:smart_event/models/event.dart';
import 'package:smart_event/resources/sizes.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/routes/app_route.dart';
import 'package:smart_event/styles/_button_style.dart';
import 'package:smart_event/views/layouts/event/content_section.dart';
import 'package:smart_event/views/layouts/event/custom_comfirmation_dialog.dart';
import 'package:smart_event/views/layouts/event/custom_registed_dialog.dart';
import 'package:smart_event/views/screens/face_verify_screen.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/styles/_text_header_style.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();
    Event event = eventController.getEventById(eventId);

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SingleChildScrollView(
              child: ContentSection(
                event: event,
                eventController: eventController,
              ),
            ),
          ),
          // Hiển thị hộp thoại xác nhận nếu showConfirmationDialog = true

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: AppSpace.spaceMedium * 2 +
                  AppSizes.buttonHeight, // Chiều cao của lớp phủ
              width: double.infinity, // Chiều rộng phủ toàn màn hình
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withOpacity(1),
                    Colors.white.withOpacity(0.5),
                  ],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     margin: EdgeInsets.only(bottom: AppSpace.spaceMedium),
          //     child: CustomButton(
          //       text: AppString.register,
          //       onPressed: () {
          //         eventController.showDialogConfirmation();
          //       },
          //       width: 68.w,
          //     ),
          //   ),
          // ),
          Obx(
            () {
              final buttonStatus = eventController.getButtonStatus(event);
              printInfo(info: 'Button status: $buttonStatus');
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: AppSpace.spaceMedium),
                  child: CustomButton(
                    text: ButtonStatus.getButtonText(
                        buttonStatus), // Hiển thị văn bản tương ứng với trạng thái
                    onPressed: () {
                      if (buttonStatus == 'register') {
                        eventController.showDialogConfirmation();
                      } else if (buttonStatus == 'check_in') {
                        Get.to(
                          FaceVerifyScreen(),
                          arguments: eventId,
                        );
                      }
                    },
                    isDisabled: buttonStatus == 'disabled' ||
                        buttonStatus == 'absent' ||
                        buttonStatus == 'checked_in',
                    width: 68.w,
                  ),
                ),
              );
            },
          ),

          Obx(
            () {
              if (eventController.showConfirmationDialog.value) {
                return Positioned.fill(
                  child: GestureDetector(
                    onTap: () => eventController.cancelRegistration(),
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: CustomConfirmationDialog(
                          eventController: eventController,
                          title: event.title,
                          eventId: event.id,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return SizedBox
                  .shrink(); // Nếu không có hộp thoại thì trả về không gian rỗng
            },
          ),
          // Hiển thị hộp thoại thành công nếu showSuccessDialog = true
          Obx(
            () {
              if (eventController.showSuccessDialog.value) {
                return Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      eventController.showSuccessDialog.value = false;
                    },
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Container(
                          height: 20.h,
                          padding: EdgeInsets.all(AppSizes.brMain),
                          margin: EdgeInsets.symmetric(
                              horizontal: AppSpace.spaceMain),
                          decoration: AppButtonStyle.buttonShadowDecor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Lottie.network(
                                    'https://lottie.host/9758fa3a-a675-4e31-a50a-956089bf7b3c/4qfs3HGqP6.json',
                                    width: 80.px,
                                    height: 80.px),
                              ),
                              SizedBox(height: 10),
                              Text(
                                AppString.eventRegistionSuccess,
                                style: AppTextStyle.textBody3Style,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
          Obx(
            () {
              if (eventController.showRegistration.value) {
                return Positioned.fill(
                  child: GestureDetector(
                    onTap: () => eventController.cancelRegistration(),
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: CustomRegistedDialog(
                          eventController: eventController,
                          event: event,
                          title: event.title,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return SizedBox
                  .shrink(); // Nếu không có hộp thoại thì trả về không gian rỗng
            },
          ),
        ],
      ),
    );
  }
}

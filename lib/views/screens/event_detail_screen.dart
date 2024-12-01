import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/models/event.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/resources/sizes.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/styles/_button_style.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/views/widgets/custom_button_icon.dart';
import 'package:smart_event/views/layouts/custom_header.dart';

import '../../styles/_text_header_style.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.put(EventController());
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: AppSpace.spaceMedium),
              child: CustomButton(
                text: "Register",
                onPressed: () {
                  eventController.showDialogConfirmation();
                },
                width: 68.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContentSection extends StatelessWidget {
  const ContentSection({
    super.key,
    required this.event,
    required this.eventController,
  });

  final Event event;
  final EventController eventController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
              bottom: AppSpace.spaceMedium * 2 + AppSizes.buttonHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppImage.imgTest1,
                height: AppSizes.eventCoverHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: AppSpace.spaceMain,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.spaceMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTextStyle.textH2Style,
                    ),
                    SizedBox(
                      height: AppSpace.spaceMedium,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMedium,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMain,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMain,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMain,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMain,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMain,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMain,
                    ),
                    Row(
                      children: [
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_calendar_f,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 December, 2021",
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              "Tuesday, 4:00PM - 9:00PM",
                              style: AppTextStyle.textSubTitle2Style,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpace.spaceMedium,
                vertical: AppSpace.paddingMain,
              ),
              child: CustomHeader(
                prefixOnTap: () => eventController.goBackScreen(),
                headerTitle: AppString.eventDetailTitle,
                textStyle: AppTextStyle.textTitle1DarkStyle,
                prefixIconImage: AppIcons.ic_back,
                prefixIconWidth: AppSizes.iconNavSize,
                prefixIconHeight: AppSizes.iconNavSize,
                prefixIconColor: AppColors.whiteColor,
                sufixIconImage: AppIcons.ic_calendar,
                sufixIconColor: AppColors.whiteColor,
              ),
            ),
          ),
        ),
        Positioned(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpace.spaceMain),
                child: Container(
                  margin: EdgeInsets.only(
                    top: AppSizes.eventCoverHeight - AppSizes.buttonHeight / 2,
                  ),
                  height: AppSizes.buttonHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(30.px),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.buttonShadowColor,
                        offset: Offset(0, 4),
                        blurRadius: 4 * 2,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpace.spaceMedium,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30.px,
                              width: 65.px,
                              child: Stack(
                                children: [
                                  for (int i = 0; i < 3; i++)
                                    Positioned(
                                      left: i * 18.0,
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundImage: AssetImage(
                                            eventController
                                                .events[1].attendees[i],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              "+${eventController.events[1].attendees.length - 3} Going",
                              style: AppTextStyle.textHighlightBody,
                            ),
                          ],
                        ),
                        CustomButton(
                          onPressed: () {},
                          width: 67,
                          height: 25,
                          text: "Invite",
                          isUppercase: false,
                          textStyle: AppTextStyle.textButtonSmallStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomConfirmationDialog extends StatelessWidget {
  final EventController eventController;
  final String title;

  const CustomConfirmationDialog(
      {super.key, required this.eventController, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpace.spaceMain),
      padding: EdgeInsets.all(AppSpace.paddingMain),
      decoration: AppButtonStyle.buttonShadowDecor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                'Bạn có muốn đăng ký sự kiện',
                style: AppTextStyle.textTitle3Style,
                textAlign: TextAlign.center,
              ),
              Text(
                title,
                style: AppTextStyle.textHighlightTitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                text: AppString.cancel,
                width: 100.px,
                height: 45.px,
                radius: 7.px,
                isFill: false,
                textStyle: AppTextStyle.textButtonHighlightStyle,
                onPressed: () {
                  eventController.cancelRegistration();
                },
              ),
              SizedBox(width: AppSpace.spaceSmallW),
              CustomButton(
                text: AppString.agree,
                width: 130.px,
                height: 45.px,
                radius: 7.px,
                onPressed: () {
                  eventController.confirmRegistration();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

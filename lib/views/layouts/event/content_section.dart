import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/models/event.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/resources/sizes.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/styles/_text_header_style.dart';
import 'package:smart_event/views/layouts/custom_header.dart';
import 'package:smart_event/views/layouts/event/custom_registed_dialog.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/views/widgets/custom_button_icon.dart';

class ContentSection extends StatelessWidget {
  final Event event;
  final EventController eventController;

  const ContentSection({
    super.key,
    required this.event,
    required this.eventController,
  });

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
              Image.network(
                event.thumbnail ?? AppImage.eventDefault,
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
                              event.formattedDate,
                              style: AppTextStyle.textBody1Style,
                            ),
                            Text(
                              '${event.weekday} | ${event.formattedStartTime} - ${event.formattedEndTime}',
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
                          iconImagePath: AppIcons.ic_map,
                          width: 48.px,
                          height: 48.px,
                          backgroundColor: AppColors.primaryShadowColor,
                          radius: AppSizes.brMain,
                        ),
                        SizedBox(
                          width: AppSpace.spaceMedium,
                        ),
                        Text(
                          event.location,
                          style: AppTextStyle.textBody1Style,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceMain,
                    ),
                    Text(
                      AppString.aboutEvent,
                      style: AppTextStyle.textH4Style,
                    ),
                    SizedBox(
                      height: AppSpace.spaceMedium,
                    ),
                    Text(
                      event.description ?? AppString.noAwswer,
                      style: AppTextStyle.textBody2Style,
                    ),
                    SizedBox(
                      height: AppSpace.spaceMedium,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (event.registrations.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: AppSizes.buttonHeight / 2,
                                width: 65.px,
                                child: Stack(
                                  children: [
                                    for (int i = 0;
                                        i <
                                            (event.registrations.length > 3
                                                ? 3
                                                : event.registrations.length);
                                        i++)
                                      Positioned(
                                        left: i * 18.0,
                                        child: Container(
                                          height: 24,
                                          width: 24,
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundImage: NetworkImage(
                                              event.registrations[i].avatar
                                                      .isNotEmpty
                                                  ? event
                                                      .registrations[i].avatar
                                                  : AppImage
                                                      .imgAvatarDefault, // URL mặc định nếu không có avatar
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (event.registrations.length > 3) ...[
                                Text(
                                  "+${event.registrations.length > 3 ? event.registrations.length - 3 : 0} Going",
                                  style: AppTextStyle.textHighlightBody,
                                ),
                              ] else ...[
                                SizedBox.shrink(),
                              ],
                            ],
                          ),
                        ] else ...[
                          Text(
                            'No one register',
                            style: AppTextStyle.textHighlightBody,
                          )
                        ],
                        CustomButton(
                          onPressed: () {
                            eventController.showRegistrated();
                          },
                          width: 67.px,
                          height: 25.px,
                          text: AppString.seeAll,
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

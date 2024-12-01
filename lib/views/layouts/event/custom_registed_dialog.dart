import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:smart_event/styles/_text_header_style.dart';
import 'package:smart_event/utils/formatter.dart';
import 'package:smart_event/views/widgets/custom_button.dart';
import 'package:smart_event/views/widgets/custom_button_icon.dart';

class CustomRegistedDialog extends StatelessWidget {
  final EventController eventController;
  final Event event;
  final String title;

  const CustomRegistedDialog({
    super.key,
    required this.eventController,
    required this.title,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpace.spaceMain),
      padding: EdgeInsets.all(AppSpace.spaceMedium),
      decoration: AppButtonStyle.buttonShadowDecor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Text(
                'Registration List',
                style: AppTextStyle.textTitle2Style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: AppSpace.spaceSmall),
          Container(
            height: 50.h,
            child: ListView.builder(
              itemCount: event.registrations.length,
              itemBuilder: (context, index) {
                final registration = event.registrations[index];
                return Container(
                  margin: EdgeInsets.only(bottom: AppSpace.spaceMedium),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              registration.avatar.isNotEmpty
                                  ? registration.avatar
                                  : AppImage.imgAvatarDefault,
                            ),
                          ),
                          SizedBox(
                            width: AppSpace.spaceMedium,
                          ),
                          Text(
                            registration.fullName,
                            style: AppTextStyle.textBody1Style,
                          ),
                        ],
                      ),
                      CustomButton(
                        onPressed: () {},
                        width: 67.px,
                        height: 25.px,
                        radius: 5.px,
                        text: AppFormatter.getStatusText(registration.status!),
                        isUppercase: false,
                        textStyle: AppTextStyle.textSubTitle3Style.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

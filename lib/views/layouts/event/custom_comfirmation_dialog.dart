import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/styles/_button_style.dart';
import 'package:smart_event/styles/_text_header_style.dart';
import 'package:smart_event/views/widgets/custom_button.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final EventController eventController;
  final String eventId;

  final String title;

  const CustomConfirmationDialog(
      {super.key,
      required this.eventController,
      required this.title,
      required this.eventId});

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
                  eventController.registerEvent(eventId);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

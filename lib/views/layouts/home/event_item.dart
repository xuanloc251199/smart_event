import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/views/widgets/custom_button_icon.dart';

import '../../../models/event.dart';
import '../../../resources/colors.dart';
import '../../../resources/icons.dart';
import '../../../resources/sizes.dart';
import '../../../resources/spaces.dart';
import '../../../styles/_text_header_style.dart';
import '../../widgets/icon_image_widget.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
    required this.index,
    required this.eventList,
  });

  final int index;
  final List<Event> eventList;

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find();

    return GestureDetector(
      onTap: () {
        eventController
            .navigateToEventDetail(eventController.events[index].id.toString());
      },
      child: Container(
        margin: EdgeInsets.only(right: 20, bottom: 5.h),
        width: 238.px,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhiteColor,
          borderRadius: BorderRadius.circular(AppSizes.brListItem),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryShadowColor,
              spreadRadius: 2,
              blurRadius: AppSizes.brMain,
              offset: const Offset(5, 5),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 131.px,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSizes.brMain),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.brMain),
                      child: Image.asset(
                        eventList[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 68.px,
                          height: 45.px,
                          decoration: BoxDecoration(
                            color:
                                AppColors.backgroundWhiteColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                eventList[index].day,
                                style: AppTextStyle.textButtonHighlightStyle,
                              ),
                              Text(
                                eventList[index].monthName.toUpperCase(),
                                style: AppTextStyle.textSubTitle3Style,
                              ),
                            ],
                          ),
                        ),
                        CustomButtonIcon(
                          iconImagePath: AppIcons.ic_bookmark_f,
                          width: 30.px,
                          height: 30.px,
                          backgroundColor:
                              AppColors.backgroundWhiteColor.withOpacity(0.7),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventList[index].title,
                      style: AppTextStyle.textTitle2Style,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: AppSpace.spaceSmall,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                            eventList[index].attendees[i],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              "+${eventList[index].attendees.length - 3} Going",
                              style: AppTextStyle.textHighlightBody,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSpace.spaceSmallW,
                    ),
                    Row(
                      children: [
                        IconImageWidget(
                          iconImagePath: AppIcons.ic_map,
                          width: 15.px,
                        ),
                        SizedBox(
                          width: AppSpace.spaceSmall,
                        ),
                        Expanded(
                          child: Text(
                            eventList[index].location,
                            style: AppTextStyle.textSubTitle1Style,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

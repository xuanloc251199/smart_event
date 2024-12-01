import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/views/layouts/home/event_item.dart';

import '../../../controllers/event_controller.dart';
import '../../../resources/spaces.dart';
import '../../../resources/strings.dart';
import '../../widgets/section_header.dart';

class EventSection extends StatelessWidget {
  const EventSection({
    super.key,
    required this.eventController,
  });

  final EventController eventController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpace.paddingMain),
          child: SectionHeader(title: AppString.upComing),
        ),
        SizedBox(
          height: AppSpace.spaceSmall,
        ),
        Obx(
          () {
            if (eventController.events.isEmpty) {
              return Center(
                child: Text(
                  "No upcoming events.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }
            return Container(
              padding: EdgeInsets.only(left: AppSpace.paddingMain),
              height: 36.5.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eventController.events.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: EventItem(
                      index: index,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

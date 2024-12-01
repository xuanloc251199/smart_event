import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/views/widgets/custom_button_icon.dart';

import '../../../models/event.dart';
import '../../../resources/colors.dart';
import '../../../resources/icons.dart';
import '../../../resources/sizes.dart';
import '../../../resources/spaces.dart';
import '../../../styles/_text_header_style.dart';

class EventItem extends StatelessWidget {
  final int index;
  final List<Event> eventList;

  const EventItem({
    Key? key,
    required this.index,
    required this.eventList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final event = eventList[index];

    return GestureDetector(
      onTap: () {
        // Điều hướng đến màn hình chi tiết sự kiện
        Get.toNamed('/event-detail', arguments: event.id);
      },
      child: Container(
        margin: EdgeInsets.only(right: 20, bottom: 5.h),
        width: 238.px,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                event.thumbnail ?? AppImage.imgEventDefault,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image, size: 120),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    event.location,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${event.date.day}-${event.date.month}-${event.date.year} ${event.date.hour}:${event.date.minute}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

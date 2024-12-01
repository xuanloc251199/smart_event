import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/controllers/event_controller.dart';
import 'package:smart_event/models/event.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/images.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/views/layouts/custom_header.dart';

import '../../styles/_button_style.dart';
import '../../styles/_text_header_style.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/icon_image_widget.dart';

class SearchScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpace.spaceMedium,
                  vertical: AppSpace.paddingMain,
                ),
                child: CustomHeader(
                  isPreFixIcon: false,
                  isSuFixIcon: false,
                  headerTitle: AppString.labelSearch,
                  textStyle: AppTextStyle.textTitle1Style,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpace.spaceMedium,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldWidget(
                        onChanged: (value) {
                          // Lọc danh sách sự kiện theo từ khóa tìm kiếm
                          eventController.events.value = eventController.events
                              .where((event) => event.title
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        },
                        hintText: AppString.searchHint,
                        isFill: true,
                        prefixImage: AppIcons.ic_search,
                        prefixColor: AppColors.hidenColor,
                      ),
                    ),
                    SizedBox(width: AppSpace.spaceMedium),
                    GestureDetector(
                      onTap: () {},
                      child: IconImageWidget(
                        iconImagePath: AppIcons.ic_filter,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: AppSpace.spaceMedium,
              ),
              // Danh sách sự kiện
              Expanded(
                child: Obx(() {
                  if (eventController.events.isEmpty) {
                    return const Center(
                      child: Text(
                        "No events found!",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: eventController.events.length,
                    itemBuilder: (context, index) {
                      Event event = eventController.events[index];
                      return _buildEventItem(event);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget để hiển thị một sự kiện
  Widget _buildEventItem(Event event) {
    return GestureDetector(
      onTap: () {
        eventController.navigateToEventDetail(event.id);
      },
      child: Container(
        margin: EdgeInsets.only(
            left: AppSpace.spaceMedium,
            right: AppSpace.spaceMedium,
            bottom: AppSpace.spaceMedium),
        padding: EdgeInsets.all(AppSpace.spaceSmall),
        decoration: AppButtonStyle.buttonShadowDecor,
        child: Row(
          children: [
            // Hình ảnh sự kiện
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                event.thumbnail ?? AppImage.imgEventDefault,
                width: 79.px,
                height: 92.px,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Thông tin sự kiện
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "${event.day} • ${event.monthName}",
                  //   style: AppTextStyle.textHighlightBody,
                  // ),
                  Text(event.title, style: AppTextStyle.textTitle2Style),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

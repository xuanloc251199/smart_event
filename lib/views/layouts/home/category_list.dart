import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_event/controllers/category_controller.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/views/widgets/custom_button_icon.dart';
import 'package:smart_event/views/widgets/custom_button_network_image.dart';

class CategoryList extends StatelessWidget {
  final CategoryController controller;

  const CategoryList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: EdgeInsets.only(left: 16),
      child: Obx(() {
        if (controller.categories.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            print("thumbail: ${category.thumbnail}");
            return GestureDetector(
              onTap: () {
                // Xử lý sự kiện khi nhấn vào danh mục
                controller.navigateToEventDetail(category.id.toString());
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    CustomButtonNetworkImage(
                      width: 100,
                      height: 80,
                      iconImageUrl: category.thumbnail,
                      iconWidth: 45,
                      iconHeight: 45,
                      padding: 20,
                      backgroundColor: AppColors.buttonShadowColor,
                      isTitle: true,
                      title: category.name,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

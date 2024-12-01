import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/resources/colors.dart';
import '../../controllers/bottom_nav_controller.dart';
import '../../resources/icons.dart';
import '../../resources/sizes.dart';
import '../../resources/strings.dart';
import '../widgets/icon_image_widget.dart';

class CustomBottomNavBar extends StatelessWidget {
  final BottomNavController bottomNavController =
      Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.1),
            blurRadius: AppSizes.brMain,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Row chứa các mục bên trái và phải
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(null, AppIcons.ic_home, AppString.labelHome, 0),
                _buildNavItem(
                    null, AppIcons.ic_search, AppString.labelSearch, 1),
                SizedBox(width: 12.w),
                _buildNavItem(null, AppIcons.ic_map, AppString.labelMap, 3),
                _buildNavItem(
                    null, AppIcons.ic_profile_f, AppString.labelProfile, 4),
              ],
            ),
          ),
          Positioned(
            top: -3.h, // Đẩy icon nổi lên trên
            left: 50.w - AppSizes.iconWidth / 2,
            child: GestureDetector(
              onTap: () => bottomNavController.changeTabIndex(2),
              child: Container(
                  width: AppSizes.iconWidth,
                  height: AppSizes.iconWidth,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: IconImageWidget(
                      iconImagePath: AppIcons.ic_event,
                      iconColor: AppColors.whiteColor,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData? icon, String? imageUrl, String label, int index) {
    return GestureDetector(
      onTap: () => bottomNavController.changeTabIndex(index),
      child: Obx(() {
        final isSelected = bottomNavController.selectedIndex.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 28.px,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.hidenColor.withOpacity(0.2),
                  )
                : Image.asset(
                    imageUrl!,
                    width: AppSizes.iconNavSize,
                    height: AppSizes.iconNavSize,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.hidenColor.withOpacity(0.2),
                  ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.hidenColor.withOpacity(0.2),
              ),
            ),
          ],
        );
      }),
    );
  }
}

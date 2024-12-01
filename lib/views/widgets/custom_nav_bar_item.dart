import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/models/nav_bar_item.dart';

import '../../resources/colors.dart';
import '../../resources/sizes.dart';

class CustomNavBarItem extends StatelessWidget {
  final NavBarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomNavBarItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          item.icon != null
              ? Icon(
                  item.icon,
                  size: 28.px,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.hidenColor.withOpacity(0.2),
                )
              : Image.asset(
                  item.imagePath!,
                  width: AppSizes.iconNavSize,
                  height: AppSizes.iconNavSize,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.hidenColor.withOpacity(0.2),
                ),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.hidenColor.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/sizes.dart';
import 'package:smart_event/styles/_text_header_style.dart';

class CustomButtonActionIcon extends StatelessWidget {
  final String text;
  final String iconImage;
  final bool isPrimary;
  final Function()? onPreesed;

  const CustomButtonActionIcon(
      {super.key,
      required this.text,
      required this.iconImage,
      required this.isPrimary,
      this.onPreesed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPreesed,
      icon: Image.asset(iconImage,
          width: AppSizes.iconButtonSize,
          color: isPrimary ? AppColors.whiteColor : AppColors.primaryColor),
      label: Text(
        text,
        style: AppTextStyle.textButtonSmallStyle.copyWith(
          color: isPrimary ? AppColors.whiteColor : AppColors.primaryColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? AppColors.primaryColor : AppColors.whiteColor,
        side: isPrimary
            ? BorderSide.none
            : BorderSide(color: AppColors.primaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shadowColor: AppColors.buttonShadowColor,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/resources/colors.dart';

import '../../resources/sizes.dart';
import '../../resources/spaces.dart';
import '../../styles/_text_header_style.dart';

class CustomSocialButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double elevation;
  const CustomSocialButton({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
    this.backgroundColor = AppColors.whiteColor,
    this.textColor = AppColors.textPrimaryColor,
    this.elevation = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60.px,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSizes.brMain),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondPrimaryColor.withOpacity(0.1),
              offset: Offset(0, elevation),
              blurRadius: elevation * 3,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.px,
              height: 40.px,
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 26.px,
                  height: 26.px,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: AppSpace.spaceMedium),
            Text(text, style: AppTextStyle.textBody2Style),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/resources/colors.dart';

import '../../resources/sizes.dart';
import '../../styles/_text_header_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? borderColor;
  final double elevation;
  final double? width;
  final double? height;
  final double? radius;
  final bool isFill;
  final bool isUppercase;
  final bool isDisabled;
  final TextStyle? textStyle;
  final TextStyle? disabledTextStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.elevation = 5.0,
    this.width,
    this.height,
    this.isFill = true,
    this.textStyle,
    this.disabledTextStyle,
    this.radius,
    this.isUppercase = true,
    this.borderColor,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        height: height ?? 60.px,
        width: width ?? double.infinity,
        decoration: isFill
            ? BoxDecoration(
                color: isDisabled
                    ? (disabledBackgroundColor ?? AppColors.iconGreyColor)
                    : (backgroundColor ?? AppColors.primaryColor),
                borderRadius: BorderRadius.circular(radius ?? AppSizes.brMain),
                boxShadow: isDisabled
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.secondPrimaryColor.withOpacity(0.1),
                          offset: Offset(0, elevation),
                          blurRadius: elevation * 2,
                          spreadRadius: 0.5,
                        ),
                      ],
              )
            : BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(radius ?? AppSizes.brMain),
                border: Border.all(
                    width: 1,
                    color: isDisabled
                        ? AppColors.hidenBackgroundColor
                        : (borderColor ?? AppColors.primaryColor)),
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                isUppercase ? text.toUpperCase() : text,
                textAlign: TextAlign.center,
                style: isDisabled
                    ? (disabledTextStyle ??
                        AppTextStyle.textButtonStyle.copyWith(
                          color: AppColors.whiteColor.withOpacity(0.6),
                        ))
                    : (textStyle ?? AppTextStyle.textButtonStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../resources/colors.dart';
import '../../../resources/sizes.dart';

class IconImageWidget extends StatelessWidget {
  final String iconImagePath;
  final double? width;
  final double? height;
  final Color? iconColor;
  final Function()? onTap;

  const IconImageWidget({
    super.key,
    required this.iconImagePath,
    this.iconColor,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        iconImagePath,
        width: width ?? AppSizes.iconNavSize,
        height: height ?? AppSizes.iconNavSize,
        color: iconColor ?? AppColors.primaryColor,
      ),
    );
  }
}

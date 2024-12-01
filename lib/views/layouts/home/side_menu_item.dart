import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../resources/colors.dart';
import '../../../resources/icons.dart';
import '../../../resources/sizes.dart';

class SideMenuItem extends StatelessWidget {
  final String title;
  final String? iconImg;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const SideMenuItem({
    super.key,
    required this.title,
    this.iconImg,
    this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        height: AppSizes.iconNavSize,
        width: AppSizes.iconNavSize,
        child: icon != null
            ? Icon(
                icon ?? CupertinoIcons.person,
                color: iconColor ?? AppColors.iconGreyColor,
              )
            : iconImg != null
                ? Image.asset(
                    iconImg ?? AppIcons.logo_shape,
                    width: AppSizes.iconNavSize,
                    color: iconColor ?? AppColors.iconGreyColor,
                  )
                : Image.asset(
                    AppIcons.ic_profile_f,
                    width: AppSizes.iconNavSize,
                    color: iconColor ?? AppColors.iconGreyColor,
                  ),
      ),
      title: Text("My Profile"),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_event/resources/colors.dart';

import '../../../resources/icons.dart';
import '../../../resources/sizes.dart';
import '../../../styles/_text_header_style.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? imgPath;
  final IconData? icon;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.subTitle,
    this.imgPath,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        child: icon != null
            ? Icon(
                icon ?? CupertinoIcons.person,
                color: iconColor ?? AppColors.whiteColor,
              )
            : imgPath != null
                ? Image.asset(
                    imgPath ?? AppIcons.logo_shape,
                    width: AppSizes.iconNavSize,
                    color: iconColor ?? AppColors.whiteColor,
                  )
                : Image.asset(
                    AppIcons.ic_profile_f,
                    width: AppSizes.iconNavSize,
                    color: iconColor ?? AppColors.whiteColor,
                  ),
      ),
      title: Text(
        title,
        style: AppTextStyle.textTitle3Style,
      ),
      subtitle: Text(
        subTitle,
        style: AppTextStyle.textHintStyle,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../resources/colors.dart';
import '../../resources/icons.dart';
import '../../resources/spaces.dart';
import '../../resources/strings.dart';
import '../../styles/_text_header_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;

  const SectionHeader({
    super.key,
    required this.title,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.textTitle1Style,
        ),
        GestureDetector(
          onTap: onPress ?? () {},
          child: Row(
            children: [
              Text(
                AppString.seeAll,
                style: AppTextStyle.textBody1Style,
              ),
              SizedBox(
                width: AppSpace.spaceSmallW,
              ),
              Image.asset(
                AppIcons.ic_right_f,
                height: 10.px,
                color: AppColors.iconGreyColor,
              )
            ],
          ),
        ),
      ],
    );
  }
}

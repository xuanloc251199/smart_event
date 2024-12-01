import 'package:flutter/cupertino.dart';
import 'package:smart_event/resources/colors.dart';

import '../resources/sizes.dart';

class AppButtonStyle {
  static BoxDecoration get buttonPrimaryDecor => BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(AppSizes.brListItem),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadowColor,
            spreadRadius: 2,
            blurRadius: AppSizes.brMain,
            offset: const Offset(5, 5),
          )
        ],
      );
  static BoxDecoration get buttonShadowDecor => BoxDecoration(
        color: AppColors.backgroundWhiteColor,
        borderRadius: BorderRadius.circular(AppSizes.brListItem),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadowColor,
            spreadRadius: 2,
            blurRadius: AppSizes.brMain,
            offset: const Offset(5, 5),
          )
        ],
      );
}

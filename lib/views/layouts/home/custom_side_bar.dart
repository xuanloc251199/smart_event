import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/views/layouts/home/info_card.dart';
import 'package:smart_event/views/layouts/home/side_menu_title.dart';
import '../../../resources/colors.dart';
import '../../../resources/sizes.dart';
import '../../../resources/spaces.dart';
import '../../../resources/strings.dart';

class CustomSideBar extends StatelessWidget {
  const CustomSideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpace.spaceLarge),
      child: Container(
        width: 75.w,
        height: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundWhiteColor,
          borderRadius: BorderRadius.circular(AppSizes.brMain),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: 2,
              blurRadius: AppSizes.blurRadiusLarge,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: AppSpace.spaceSmall),
            child: Column(
              children: [
                InfoCard(
                  title: AppString.appName,
                  subTitle: AppString.emailHint,
                ),
                SideMenuTitle()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

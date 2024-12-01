import 'package:flutter/material.dart';
import 'package:smart_event/views/layouts/home/side_menu_item.dart';

import '../../../resources/icons.dart';
import '../../../resources/strings.dart';

class SideMenuTitle extends StatelessWidget {
  const SideMenuTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SideMenuItem(
          title: AppString.titleProfile,
          onTap: () {},
          iconImg: AppIcons.ic_user,
        ),
        SideMenuItem(
          title: AppString.titleMassage,
          onTap: () {},
          iconImg: AppIcons.ic_massage,
        ),
        SideMenuItem(
          title: AppString.titleCalendar,
          onTap: () {},
          iconImg: AppIcons.ic_calendar,
        ),
        SideMenuItem(
          title: AppString.titleBookmark,
          onTap: () {},
          iconImg: AppIcons.ic_bookmark,
        ),
        SideMenuItem(
          title: AppString.titleContact,
          onTap: () {},
          iconImg: AppIcons.ic_contact,
        ),
        SideMenuItem(
          title: AppString.titleSetting,
          onTap: () {},
          iconImg: AppIcons.ic_setting,
        ),
        SideMenuItem(
          title: AppString.titleHelp,
          onTap: () {},
          iconImg: AppIcons.ic_help,
        ),
        SideMenuItem(
          title: AppString.titleSignOut,
          onTap: () {},
          iconImg: AppIcons.ic_sign_out,
        ),
      ],
    );
  }
}

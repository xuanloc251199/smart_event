import 'package:flutter/material.dart';

import '../../../controllers/side_bar_controller.dart';
import '../../../resources/icons.dart';
import '../../../resources/sizes.dart';
import '../../../resources/strings.dart';
import '../../../styles/_text_header_style.dart';
import '../../widgets/icon_image_widget.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.sidebarController,
  });

  final SidebarController sidebarController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            sidebarController.toggleSidebar();
          },
          child: IconImageWidget(
            iconImagePath: AppIcons.ic_menu,
            width: AppSizes.iconNavSize,
            height: AppSizes.iconNavSize,
          ),
        ),
        Text(
          AppString.labelHome.toUpperCase(),
          style: AppTextStyle.textTitle1Style,
        ),
        GestureDetector(
          onTap: () {
            sidebarController.toggleSidebar();
          },
          child: IconImageWidget(iconImagePath: AppIcons.ic_notify),
        ),
      ],
    );
  }
}

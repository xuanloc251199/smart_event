import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/spaces.dart';

import '../../styles/_text_header_style.dart';
import 'icon_image_widget.dart';

class CustomButtonNetworkImage extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconWidth;
  final double? iconHeight;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? radius;
  final double? padding;
  final String iconImageUrl;
  final String? title;
  final bool isTitle;

  const CustomButtonNetworkImage({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.radius,
    required this.iconImageUrl,
    this.padding,
    this.title,
    this.isTitle = false,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 80.px,
      height: height ?? 80.px,
      decoration: BoxDecoration(
        color:
            backgroundColor ?? AppColors.backgroundWhiteColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(radius ?? 7.px),
      ),
      child: isTitle
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.network(
                    iconImageUrl,
                    width: iconWidth ?? 12.px,
                    height: iconHeight ?? 12.px,
                    color: iconColor ?? AppColors.primaryColor,
                  ),
                  SizedBox(
                    height: AppSpace.spaceSmallW,
                  ),
                  Text(
                    title ?? '',
                    style: AppTextStyle.textSubTitle3Style,
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(padding ?? 8.0),
              child: Image.network(
                iconImageUrl,
                width: width ?? 12.px,
                height: height ?? 12.px,
                color: iconColor ?? AppColors.primaryColor,
              ),
            ),
    );
  }
}

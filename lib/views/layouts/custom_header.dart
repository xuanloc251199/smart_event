import 'package:flutter/material.dart';
import '../../resources/sizes.dart';
import '../../styles/_text_header_style.dart';
import '../widgets/icon_image_widget.dart';

class CustomHeader extends StatelessWidget {
  final String headerTitle;
  final void Function()? prefixOnTap;
  final void Function()? sufixOnTap;
  final bool isPreFixIcon;
  final String? prefixIconImage;
  final double? prefixIconWidth;
  final double? prefixIconHeight;
  final bool isSuFixIcon;
  final String? sufixIconImage;
  final double? sufixIconWidth;
  final double? sufixIconHeight;
  final Color? prefixIconColor;
  final Color? sufixIconColor;
  final TextStyle? textStyle;

  const CustomHeader({
    super.key,
    required this.headerTitle,
    this.isPreFixIcon = true,
    this.prefixIconImage,
    this.sufixIconImage,
    this.prefixIconWidth,
    this.prefixIconHeight,
    this.isSuFixIcon = true,
    this.sufixIconWidth,
    this.sufixIconHeight,
    this.prefixIconColor,
    this.sufixIconColor,
    this.textStyle,
    this.prefixOnTap,
    this.sufixOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isPreFixIcon
                ? GestureDetector(
                    onTap: () {
                      prefixOnTap?.call();
                    },
                    child: IconImageWidget(
                      iconImagePath: prefixIconImage!,
                      width: prefixIconWidth ?? AppSizes.iconNavSize,
                      height: prefixIconHeight ?? AppSizes.iconNavSize,
                      iconColor: prefixIconColor,
                    ),
                  )
                : SizedBox.shrink(),
            isSuFixIcon
                ? GestureDetector(
                    onTap: sufixOnTap,
                    child: IconImageWidget(
                      iconImagePath: sufixIconImage!,
                      width: sufixIconWidth ?? AppSizes.iconNavSize,
                      height: sufixIconHeight ?? AppSizes.iconNavSize,
                      iconColor: sufixIconColor,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        Center(
          child: Text(
            headerTitle.toUpperCase(),
            style: textStyle ?? AppTextStyle.textTitle1Style,
          ),
        ),
      ],
    );
  }
}

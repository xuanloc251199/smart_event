import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/icons.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';
import 'package:smart_event/styles/_text_header_style.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<Map<String, dynamic>> items;
  final String hint;
  final String? label;
  final TextStyle? labelStyle;

  final bool isLabel;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.isLabel = false,
    this.label,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isLabel
            ? Padding(
                padding: EdgeInsets.only(
                    left: AppSpace.spaceSmall, bottom: AppSpace.spaceSmall),
                child: Text(
                  label ?? AppString.appName,
                  style: labelStyle ?? AppTextStyle.textH5Style,
                ),
              )
            : SizedBox.shrink(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.backgroundLightColor, width: 1),
          ),
          child: DropdownButton<String>(
            value: value,
            hint: Text(hint, style: AppTextStyle.textHintStyle),
            isExpanded: true, // Đảm bảo dropdown chiếm toàn bộ chiều rộng
            dropdownColor: Colors.white,
            style: AppTextStyle.textBody1Style,
            underline: SizedBox(), // Loại bỏ gạch dưới
            icon: Image.asset(
              AppIcons.ic_dropdown,
              width: 8.px,
              color: AppColors.primaryColor,
            ),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item['id'].toString(),
                child: Padding(
                  padding: EdgeInsets.all(AppSpace.spaceSmallW),
                  child: Text(
                    item['faculty'] ?? item['class_name'], // Faculty hoặc Class
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

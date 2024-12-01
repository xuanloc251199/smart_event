import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_event/resources/colors.dart';
import 'package:smart_event/resources/spaces.dart';
import 'package:smart_event/resources/strings.dart';

import '../../../styles/_text_header_style.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final String? label;
  final TextStyle? labelStyle;
  final String? prefixImage;
  final Color? prefixColor;
  final String? suffixImage;
  final Color? suffixColor;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool? isFill;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final Function()? onSuffixIconTap;
  final String? errorText;
  final bool? isReadOnly;
  final bool isLabel;

  const CustomTextFieldWidget({
    Key? key,
    this.hintText,
    this.prefixImage,
    this.suffixImage,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSuffixIconTap,
    this.isFill,
    this.backgroundColor,
    this.prefixColor,
    this.suffixColor,
    this.errorText,
    this.isReadOnly,
    this.label,
    this.labelStyle,
    this.isLabel = false,
  }) : super(key: key);

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isLabel
            ? Padding(
                padding: EdgeInsets.only(
                    left: AppSpace.spaceSmall, bottom: AppSpace.spaceSmall),
                child: Text(
                  widget.label ?? AppString.appName,
                  style: widget.labelStyle ?? AppTextStyle.textH5Style,
                ),
              )
            : SizedBox.shrink(),
        TextField(
          readOnly: widget.isReadOnly ?? false,
          focusNode: _focusNode,
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            filled: widget.isFill,
            fillColor: widget.backgroundColor ?? AppColors.hidenBackgroundColor,
            hintText: widget.hintText,
            hintStyle: AppTextStyle.textHintStyle,
            prefixIcon: widget.prefixImage != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Image.asset(
                      widget.prefixImage!,
                      width: 3.w,
                      height: 3.w,
                      color: _isFocused
                          ? AppColors.primaryColor
                          : widget.prefixColor ?? AppColors.hidenColor,
                    ),
                  )
                : null,
            suffixIcon: widget.suffixImage != null
                ? GestureDetector(
                    onTap: widget.onSuffixIconTap,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Image.asset(
                        widget.suffixImage!,
                        width: 3.w,
                        height: 3.w,
                        color: _isFocused
                            ? AppColors.primaryColor
                            : widget.suffixColor ?? AppColors.hidenColor,
                      ),
                    ),
                  )
                : widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.onSuffixIconTap,
                        child: Icon(
                          widget.suffixIcon,
                          size: 20.sp,
                          color: _isFocused
                              ? AppColors.primaryColor
                              : widget.suffixColor ?? AppColors.hidenColor,
                        ),
                      )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.backgroundLightColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.backgroundLightColor),
            ),
            focusColor: AppColors.primaryColor,
            contentPadding:
                EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: AppSpace.spaceSmall),
            child: Text(
              widget.errorText!,
              style: AppTextStyle.textErrorStyle,
            ),
          ),
      ],
    );
  }
}

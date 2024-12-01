import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_event/resources/colors.dart';

import '../../resources/sizes.dart';

class AppTextStyle {
  static TextStyle get textH1Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsH1,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get textH2Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsH2,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get textH3Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsH3,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get textH3InputStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsH3,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get textH4Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsH4,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get textH4InputStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsH4,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get textH5Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsH5,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get textTitle1Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsTitle1,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get textTitle1DarkStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsTitle1,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      );
  static TextStyle get textTitle2Style => GoogleFonts.montserrat(
      fontSize: AppSizes.tsTitle2,
      fontWeight: FontWeight.bold,
      color: AppColors.blackColor);
  static TextStyle get textTitle3Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsTitle3,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get textSubTitle1Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsSubTitle1,
        fontWeight: FontWeight.w400,
        color: AppColors.textHintColor,
      );
  static TextStyle get textSubTitle2Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsSubTitle2,
        fontWeight: FontWeight.w400,
        color: AppColors.textHintColor,
      );
  static TextStyle get textSubTitle3Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsSubTitle3,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get textBody1Style => GoogleFonts.montserrat(
      fontSize: AppSizes.tsBody1,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryColor);
  static TextStyle get textBody2Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsBody2,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get textBody3Style => GoogleFonts.montserrat(
        fontSize: AppSizes.tsBody3,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get textButtonStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsButton,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      );
  static TextStyle get textButtonSmallStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsBody3,
        fontWeight: FontWeight.w500,
        color: AppColors.whiteColor,
      );
  static TextStyle get textButtonHighlightStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsButton,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryColor,
      );
  static TextStyle get textHighlightTitle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsTitle2,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      );
  static TextStyle get textHighlightBody => GoogleFonts.montserrat(
        fontSize: AppSizes.tsBody3,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryColor,
      );
  static TextStyle get textHintStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsHint,
        fontWeight: FontWeight.w400,
        color: AppColors.textHintColor,
      );
  static TextStyle get textMainStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsMain,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get textErrorStyle => GoogleFonts.montserrat(
        fontSize: AppSizes.tsSubTitle2,
        fontWeight: FontWeight.w400,
        color: AppColors.redColor,
      );
}

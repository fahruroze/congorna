import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:congorna/src/styles/colors.dart';

abstract class TextStyles {
  static TextStyle get title {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: AppColors.darkblue,
            fontWeight: FontWeight.bold,
            fontSize: 40.0));
  }

  static TextStyle get header {
    return TextStyle(
        color: AppColors.purpleViolet,
        fontWeight: FontWeight.bold,
        fontSize: 23.0,
        fontFamily: 'Hagrid');
  }

  static TextStyle get subtitle {
    return GoogleFonts.economica(
        textStyle: TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.bold,
            fontSize: 30.0));
  }

  static TextStyle get navTitle {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
      color: AppColors.darkblue,
      fontWeight: FontWeight.bold,
    ));
  }

  static TextStyle get navTitleMaterial {
    return GoogleFonts.poppins(
        textStyle:
            TextStyle(color: AppColors.putih, fontWeight: FontWeight.bold));
  }

  static TextStyle get loginText {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.purpleViolet, fontSize: 16.0));
  }

  static TextStyle get onBoardText {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: AppColors.hitam,
            fontSize: 23.0,
            fontWeight: FontWeight.w700));
  }

  static TextStyle get subOnBoardText {
    return GoogleFonts.poppins(
        textStyle: TextStyle(
            color: AppColors.hitam,
            fontSize: 17.0,
            fontWeight: FontWeight.normal));
  }

  static TextStyle get normal {
    return TextStyle(
        color: AppColors.hitam,
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'BigJohnPRO');
  }

  static TextStyle get light {
    return TextStyle(
        color: AppColors.hitam, fontSize: 17.0, fontFamily: 'BigJohnPRO');
  }

  static TextStyle get body {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.darkgray, fontSize: 16.0));
  }

  static TextStyle get bodyBlue {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.lightblue, fontSize: 16.0));
  }

  static TextStyle get bodyRed {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.red, fontSize: 16.0));
  }

  static TextStyle get suggestion {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.lightgray, fontSize: 16.0));
  }

  static TextStyle get error {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.red, fontSize: 12.0));
  }

  static TextStyle get buttonTextLight {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold));
  }

  static TextStyle get link {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
            color: AppColors.jinggaSore,
            fontSize: 16.0,
            fontWeight: FontWeight.bold));
  }

  static TextStyle get picker {
    return GoogleFonts.roboto(
        textStyle: TextStyle(color: AppColors.darkgray, fontSize: 35.0));
  }
}

import 'package:flutter/material.dart';
import 'package:congorna/src/styles/base.dart';
import 'package:congorna/src/styles/colors.dart';
import 'package:congorna/src/styles/text.dart';

abstract class JasaDetailStyles {
  static double get TextBoxHorizontal => BaseStyles.listFieldHorizontal;

  static double get TextBoxVertical => BaseStyles.listFieldVertical;

  static TextStyle get text => TextStyles.body;

  static TextStyle get placeHolder => TextStyles.suggestion;

  static Color get cursorColor => AppColors.darkblue;

  static Widget iconPrefix(IconData icon) => BaseStyles.iconPrefix(icon);

  static TextAlign get textAlign => TextAlign.center;

  static BoxDecoration cupertinoDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.brown,
        width: BaseStyles.borderWidth,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
    );
  }

  static BoxDecoration cupertinoErrorDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: AppColors.brown,
        width: BaseStyles.borderWidth,
      ),
      borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
    );
  }

  static InputDecoration materialDecoration(
      String hintText, IconData icon, String errorText) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(8.0),
      hintText: hintText,
      hintStyle: JasaDetailStyles.placeHolder,
      border: InputBorder.none,
      errorText: errorText,
      errorStyle: TextStyles.error,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.purpleViolet,
            width: BaseStyles.borderWidth,
          ),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.purpleM, width: BaseStyles.borderWidth),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.red, width: BaseStyles.borderWidth),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.red, width: BaseStyles.borderWidth),
          borderRadius: BorderRadius.circular(BaseStyles.borderRadius)),
      prefixIcon: iconPrefix(icon),
    );
  }
}

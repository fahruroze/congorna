import 'package:flutter/material.dart';
import 'package:congorna/src/styles/colors.dart';

abstract class TabBarStyles {
  static Color get unselectedLabelColor => AppColors.lightgray;

  static Color get labelColor => AppColors.thirdColor;

  static Color get indicatorColor => AppColors.thirdColor;
}

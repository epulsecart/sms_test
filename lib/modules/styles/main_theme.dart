import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData appThemeData = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.backgroundColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    onError: Colors.redAccent,
  ),
);

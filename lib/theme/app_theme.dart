import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      toolbarHeight: 40,
      color: AppColors.primary,
      // titleTextStyle: AppTextStyle.body1.copyWith(color: Colors.black),
      elevation: 0.2,
      // centerTitle: true,
      // iconTheme: IconThemeData(color: AppColors.grays[6]),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 5,
        ),
        minimumSize: const Size(36, 36),
        fixedSize: const Size(40, 36),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: AppColors.primary,
      ),
    ),
    toggleButtonsTheme: const ToggleButtonsThemeData(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderColor: AppColors.secondary,
      color: AppColors.secondary,
      selectedBorderColor: AppColors.secondary,
      selectedColor: Colors.white,
      fillColor: AppColors.secondary,
      constraints: BoxConstraints(
        minHeight: 36.0,
        minWidth: 36.0,
      ),
    ),
  );
}

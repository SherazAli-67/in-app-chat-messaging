import 'package:flutter/material.dart';
import 'package:in_app_messaging/src/res/app_colors.dart';

class AppTheme{
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.amberYellowColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(

            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
        )
    ),
    // dividerColor: dividerLightColor,
    colorScheme: const ColorScheme.dark( primary: Colors.black,),
  );
}
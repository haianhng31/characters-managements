import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromRGBO(162, 29, 19, 1);
  static Color primaryAccent = const Color.fromRGBO(120, 14, 14, 1);
  static Color secondaryColor = const Color.fromRGBO(45, 45, 45, 1);
  static Color secondaryAccent = const Color.fromRGBO(35, 35, 35, 1);
  static Color titleColor = const Color.fromRGBO(200, 200, 200, 1);
  static Color textColor = const Color.fromRGBO(150, 150, 150, 1);
  static Color successColor = const Color.fromRGBO(9, 149, 110, 1);
  static Color highlightColor = const Color.fromRGBO(212, 172, 13, 1);
}

// class AppColors {
//   static Color primaryColor = const Color.fromRGBO(229, 142, 138, 1); // Pastel red
//   static Color primaryAccent = const Color.fromRGBO(186, 121, 121, 1); // Lighter pastel red
//   static Color secondaryColor = const Color.fromRGBO(195, 195, 213, 1); // Pastel blue
//   static Color secondaryAccent = const Color.fromRGBO(166, 166, 191, 1); // Lighter pastel blue
//   static Color titleColor = const Color.fromRGBO(90, 90, 90, 1); // Dark gray
//   static Color textColor = const Color.fromRGBO(120, 120, 120, 1); // Medium gray
//   static Color successColor = const Color.fromRGBO(126, 211, 161, 1); // Pastel green
//   static Color highlightColor = const Color.fromRGBO(240, 194, 123, 1); // Pastel orange
// }


ThemeData primaryTheme = ThemeData(
  // seed
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
  ),

  // scaffold color 
  scaffoldBackgroundColor: AppColors.secondaryAccent,

  // app bar theme color 
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.secondaryColor,
    foregroundColor: AppColors.textColor,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),

  // text 
  // can do: TextTheme().copyWith()
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 1
    ),
    headlineMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1
    ),
    titleMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 2
    ),
  ),

  // card theme 
  cardTheme: CardTheme(
    color: AppColors.secondaryColor.withOpacity(0.5),
    surfaceTintColor: Colors.transparent,
    shape: const RoundedRectangleBorder(),
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.only(bottom: 16)
  ),

  // input decoration theme 
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.secondaryColor.withOpacity(0.5),
    border: InputBorder.none, 
    labelStyle: TextStyle(color: AppColors.textColor),
    prefixIconColor: AppColors.textColor,
  ),

  dialogTheme: DialogTheme(
    backgroundColor: AppColors.secondaryAccent,
    surfaceTintColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16))
    )
  )
);
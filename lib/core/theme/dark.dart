import 'package:flutter/material.dart';

OutlineInputBorder border = OutlineInputBorder(
  borderSide: BorderSide(width: 3, color: Colors.grey.shade300),
  borderRadius: BorderRadius.circular(10),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade700,
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
    fillColor: Colors.grey.shade800,
    filled: true,
    hintStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade400,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: border,
    errorBorder: border,
    focusedErrorBorder: border,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.grey.shade300,
      fontWeight: FontWeight.w600,
    ),
  ),
  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);

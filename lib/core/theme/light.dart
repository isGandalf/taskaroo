import 'package:flutter/material.dart';

OutlineInputBorder border = OutlineInputBorder(
  borderSide: BorderSide(width: 3, color: Colors.grey.shade900),
  borderRadius: BorderRadius.circular(10),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade500,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: border,
    focusedErrorBorder: border,
    errorBorder: border,
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
      color: Colors.grey.shade900,
      fontWeight: FontWeight.w500,
    ),
  ),
  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade900,
    ),
    contentPadding: EdgeInsets.all(15),
  ),
);

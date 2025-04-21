import 'package:flutter/material.dart';

void showCustomSnackbar(
  BuildContext context,
  String text,
  Color backgroundColor,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      backgroundColor: backgroundColor,
    ),
  );
}

import 'package:flutter/material.dart';

class TextFields {
  final TextEditingController controller;
  final bool isObscure;

  final String hintText;

  TextFields(
    this.isObscure, {
    required this.controller,
    required this.hintText,
  });

  static Widget textFeilds(
    TextEditingController controller,
    String hintText, [
    bool isObscure = false,
  ]) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please provide $hintText';
        }
        return null;
      },
      controller: controller,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        errorStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      obscureText: isObscure,
    );
  }
}

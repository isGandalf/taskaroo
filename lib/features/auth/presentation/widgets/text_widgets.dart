import 'package:flutter/material.dart';

class AuthPageHeading {
  final String text;

  AuthPageHeading({required this.text});

  static Widget mainHeading(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
    );
  }
}

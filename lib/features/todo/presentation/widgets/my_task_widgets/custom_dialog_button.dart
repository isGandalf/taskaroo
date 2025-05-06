import 'package:flutter/material.dart';

class CustomDialogButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final String labelText;
  final BorderRadius radius;

  const CustomDialogButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.labelText,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
          ),
          height: 50,
          child: Center(
            child: Text(
              labelText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

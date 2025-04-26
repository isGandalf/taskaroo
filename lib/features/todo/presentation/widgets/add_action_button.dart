import 'package:flutter/material.dart';

class AddActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final IconData icon;
  final BorderRadius radius;

  const AddActionButton({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.icon,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
          ),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

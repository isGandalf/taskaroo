import 'package:flutter/material.dart';

class EditActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final IconData icon;
  final BorderRadius radius;

  const EditActionButton({
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
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: radius,
          ),
          height: 50,
          child: Center(child: Icon(icon, color: Colors.white)),
        ),
      ),
    );
  }
}

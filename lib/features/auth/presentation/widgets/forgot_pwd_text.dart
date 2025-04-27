import 'package:flutter/material.dart';
import 'package:taskaroo/features/auth/presentation/pages/forgot_pwd_page.dart';

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
            );
          },
          child: Text(
            'Forgot password?  ',
            style: TextStyle(
              fontSize: 15,
              color: Colors.purpleAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

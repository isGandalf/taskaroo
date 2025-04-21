import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_signup.dart';
import 'package:taskaroo/features/auth/presentation/widgets/custom_buttons.dart';
import 'package:taskaroo/features/auth/presentation/widgets/rich_text_below_auth_page_button.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_fields.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_widgets.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailController,
    required this.passwordController,
  }) : _formKey = formKey;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TapGestureRecognizer _gestureRecognizer;

  @override
  void initState() {
    super.initState();
    _gestureRecognizer = TapGestureRecognizer()..onTap = _onTap;
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  void _onTap() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const UserSignup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          AuthPageHeading.mainHeading('Sign In.'),
          const SizedBox(height: 100),
          TextFields.textFeilds(widget.emailController, 'Email'),
          const SizedBox(height: 20),
          TextFields.textFeilds(widget.passwordController, 'Password', true),
          const SizedBox(height: 30),
          CustomButtons(
            formKey: widget._formKey,
            text: 'Sign in',
            email: widget.emailController,
            password: widget.passwordController,
            isLogin: true,
          ),
          const SizedBox(height: 15),
          RichTextBelowAuthPageButton(
            leftText: "Don't have an account? ",
            rightText: 'Sign Up.',
            tapGestureRecognizer: _gestureRecognizer,
          ),
        ],
      ),
    );
  }
}

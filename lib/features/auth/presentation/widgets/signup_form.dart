import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_login.dart';
import 'package:taskaroo/features/auth/presentation/widgets/custom_buttons.dart';
import 'package:taskaroo/features/auth/presentation/widgets/rich_text_below_auth_page_button.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_fields.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_widgets.dart';

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> _formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const SignupForm({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
  }) : _formKey = formKey;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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
      MaterialPageRoute(builder: (context) => const UserLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          AuthPageHeading.mainHeading('Sign Up.'),
          const SizedBox(height: 100),
          TextFields.textFeilds(widget.firstNameController, 'First Name'),
          const SizedBox(height: 20),
          TextFields.textFeilds(widget.lastNameController, 'Last Name'),
          const SizedBox(height: 20),
          TextFields.textFeilds(widget.emailController, 'Email'),
          const SizedBox(height: 20),
          TextFields.textFeilds(widget.passwordController, 'Password', true),
          const SizedBox(height: 30),
          CustomButtons(
            formKey: widget._formKey,
            text: 'Creat Account',
            firstName: widget.firstNameController,
            lastName: widget.lastNameController,
            email: widget.emailController,
            password: widget.passwordController,
            isLogin: false,
          ),
          const SizedBox(height: 15),
          RichTextBelowAuthPageButton(
            leftText: 'Already Have an account? ',
            rightText: 'Sign In.',
            tapGestureRecognizer: _gestureRecognizer,
          ),
        ],
      ),
    );
  }
}

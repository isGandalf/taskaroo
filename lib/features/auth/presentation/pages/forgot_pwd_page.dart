import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_login.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_fields.dart';
import 'package:taskaroo/features/auth/presentation/widgets/theme_switch.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _resetPasswordController = TextEditingController();

  @override
  void dispose() {
    _resetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 68, actions: [ThemeSwitch()]),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email to reset your password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              TextFields.textFeilds(_resetPasswordController, 'Email'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context.read<UserAuthBloc>().add(
                      ResetPasswordButtonPressedEvent(
                        email: _resetPasswordController.text.trim(),
                      ),
                    );
                  },
                  child: Text('Reset password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

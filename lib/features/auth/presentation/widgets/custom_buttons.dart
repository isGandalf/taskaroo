import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';

class CustomButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String text;
  final TextEditingController? firstName;
  final TextEditingController? lastName;
  final TextEditingController email;
  final TextEditingController password;
  final bool isLogin;

  const CustomButtons({
    super.key,

    required this.formKey,
    required this.text,
    this.firstName,
    this.lastName,
    required this.email,
    required this.password,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          if (formKey.currentState!.validate()) {
            if (isLogin) {
              //print('Login button - $isLogin');
              context.read<UserAuthBloc>().add(
                SignInButtonPressedEvent(
                  email: email.text,
                  password: password.text,
                ),
              );
            } else {
              //print('Sign up button - $isLogin');
              context.read<UserAuthBloc>().add(
                CreateAccountButtonPressedEvent(
                  firstName: firstName!.text,
                  lastName: lastName!.text,
                  email: email.text,
                  password: password.text,
                ),
              );
            }
          } else {
            showCustomSnackbar(
              context,
              "Please fill in all required fields before proceeding",
              Colors.yellow.shade700,
            );
          }
        },
        child: Text(text),
      ),
    );
  }
}

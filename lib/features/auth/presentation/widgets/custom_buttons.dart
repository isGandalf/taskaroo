import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth_bloc.dart';

class CustomButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String text;
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController password;

  const CustomButtons({
    super.key,
    required this.formKey,
    required this.text,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            context.read<UserAuthBloc>().add(
              CreateAccountButtonPressedEvent(
                firstName: firstName.text,
                lastName: lastName.text,
                email: email.text,
                password: password.text,
              ),
            );
          }
        },
        child: Text(text),
      ),
    );
  }
}

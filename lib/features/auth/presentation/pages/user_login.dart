import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
//import 'package:logger/web.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/pages/homepage.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';
import 'package:taskaroo/features/auth/presentation/widgets/login_form.dart';
import 'package:taskaroo/features/auth/presentation/widgets/toggle_theme_switch.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthBloc, UserAuthState>(
      listenWhen: (previous, current) => current is UserAuthActionState,
      listener: (context, state) async {
        _logger.d('User login --- ${state.runtimeType}');

        // Upon Login Button click
        if (state is LogInButtonClickLoadingState) {
          showCustomSnackbar(context, 'Logging in...', Colors.blue.shade800);
        }

        // Upon unsuccessful login
        if (state is LoginFailedState) {
          showCustomSnackbar(
            context,
            'Login error. Please try again.',
            Colors.red.shade800,
          );
        }
        // Upon successful login
        else if (state is LoginSuccessState) {
          showCustomSnackbar(context, 'Login success!', Colors.green.shade800);
          await Future.delayed(Duration(seconds: 2));
          if (!context.mounted) return;
          //final userId = FirebaseAuth.instance.currentUser;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Homepage(
                    userEntity: state.userEntity,
                    userId: state.userEntity.uid,
                  ),
            ),
            (route) => false,
          );
        } else if (state is ResetPasswordSuccessState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'An email with reset password link has been sent. Please check your inbox.',
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const UserLogin(),
                        ),
                      );
                    },
                    child: Text('Okay'),
                  ),
                ],
              );
            },
          );
        } else if (state is ResetPasswordFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3));
              return AlertDialog(title: Text(state.message));
            },
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 68,
            actions: [
              Row(children: [ToggleThemeSwitch()]),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: LoginForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

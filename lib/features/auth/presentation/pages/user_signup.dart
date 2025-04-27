import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:logger/logger.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';
import 'package:taskaroo/features/auth/presentation/widgets/signup_form.dart';
import 'package:taskaroo/features/auth/presentation/widgets/theme_switch.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_login.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  //final _logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserAuthBloc, UserAuthState>(
      listenWhen: (previous, current) => current is UserAuthActionState,
      listener: (context, state) async {
        //_logger.d('${state.runtimeType}');

        // After create account button clicked
        if (state is SignUpButtonClickLoadingState) {
          showCustomSnackbar(
            context,
            'Creating user profile...',
            Colors.blue.shade800,
          );
        }
        // Upon unsuccessful account creation
        else if (state is UserAuthFailureState) {
          showCustomSnackbar(
            context,
            'Failed to create user account. Please try again.',
            Colors.red.shade800,
          );
        }
        // Upon successful account creation
        else if (state is UserAuthSuccessState) {
          showCustomSnackbar(
            context,
            'User created. Please login',
            Colors.green.shade800,
          );
          await Future.delayed(Duration(seconds: 2));
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserLogin()),
          );
        }
        // Upon tapping the text Link
        else if (state is RedirectToSignInPageState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserLogin()),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 68, actions: [ThemeSwitch()]),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: SignupForm(
                formKey: _formKey,
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                emailController: emailController,
                passwordController: passwordController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

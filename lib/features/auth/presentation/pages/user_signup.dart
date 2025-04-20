import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/widgets/custom_buttons.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_fields.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_widgets.dart';
import 'package:taskaroo/features/auth/presentation/widgets/theme_switch.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<UserAuthBloc>().add(UserAuthPageLoadedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocConsumer<UserAuthBloc, UserAuthState>(
        listenWhen: (previous, current) => current is UserAuthPageLoadingState,
        listener: (context, state) {
          if (state is UserAuthPageLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Creating user profile...'),
                backgroundColor: Colors.green.shade800,
              ),
            );
          } else if (state is UserAuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to create user account. Please try again.',
                ),
                backgroundColor: Colors.red.shade800,
              ),
            );
          } else if (state is UserAuthSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User created'),
                backgroundColor: Colors.blue.shade800,
              ),
            );
          }
        },
        builder: (context, state) {
          print(state.runtimeType);
          switch (state) {
            case UserAuthPageLoadIntialState():
              return Scaffold(
                appBar: AppBar(toolbarHeight: 68, actions: [ThemeSwitch()]),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthPageHeading.mainHeading('Sign Up.'),
                          const SizedBox(height: 100),
                          TextFields.textFeilds(
                            firstNameController,
                            'First Name',
                          ),
                          const SizedBox(height: 20),
                          TextFields.textFeilds(
                            lastNameController,
                            'Last Name',
                          ),
                          const SizedBox(height: 20),
                          TextFields.textFeilds(emailController, 'Email'),
                          const SizedBox(height: 20),
                          TextFields.textFeilds(
                            passwordController,
                            'Password',
                            true,
                          ),
                          const SizedBox(height: 30),
                          CustomButtons(
                            formKey: _formKey,
                            text: 'Create account',
                            firstName: firstNameController,
                            lastName: lastNameController,
                            email: emailController,
                            password: passwordController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            default:
              return Scaffold(
                appBar: AppBar(toolbarHeight: 68, actions: [ThemeSwitch()]),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthPageHeading.mainHeading('Sign Up.'),
                          const SizedBox(height: 100),
                          TextFields.textFeilds(
                            firstNameController,
                            'First Name',
                          ),
                          const SizedBox(height: 20),
                          TextFields.textFeilds(
                            lastNameController,
                            'Last Name',
                          ),
                          const SizedBox(height: 20),
                          TextFields.textFeilds(emailController, 'Email'),
                          const SizedBox(height: 20),
                          TextFields.textFeilds(
                            passwordController,
                            'Password',
                            true,
                          ),
                          const SizedBox(height: 30),
                          CustomButtons(
                            formKey: _formKey,
                            text: 'Create account',
                            firstName: firstNameController,
                            lastName: lastNameController,
                            email: emailController,
                            password: passwordController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

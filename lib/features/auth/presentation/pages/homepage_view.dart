import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/homepage/bloc/homepage_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_login.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';
import 'package:taskaroo/features/auth/presentation/widgets/custom_drawer.dart';
import 'package:taskaroo/features/auth/presentation/widgets/theme_switch.dart';
import 'package:taskaroo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/pages/todo.dart';
import 'package:taskaroo/features/todo/presentation/widgets/add_alert_box.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _todoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomepageBloc, HomepageState>(
          listener: (context, state) {},
        ),
        BlocListener<UserAuthBloc, UserAuthState>(
          listener: (context, state) {
            //logger.d('${state.runtimeType}');
            if (state is SignOutSuccessState) {
              showCustomSnackbar(context, 'Signed out', Colors.green.shade800);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => UserLogin()),
                (route) => false,
              );
            } else if (state is SignOutFailedState) {
              showCustomSnackbar(
                context,
                'Signed out failed',
                Colors.red.shade800,
              );
            }
          },
        ),
        BlocListener<TodoBloc, TodoState>(listener: (context, state) {}),
      ],
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 68, actions: [ThemeSwitch()]),
        drawer: BlocBuilder<HomepageBloc, HomepageState>(
          builder: (context, state) {
            //logger.d('${state.runtimeType}');
            if (state is LoadHomepageDataState) {
              return CustomDrawer(
                state: LoadHomepageDataState(userEntity: state.userEntity),
              );
            } else {
              return Center(child: Text('Unable to load widgets'));
            }
          },
        ),
        body: Todo(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: FloatingActionButton(
            onPressed: createNewTodo,
            backgroundColor: Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void createNewTodo() {
    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AddAlertBox(
            todoController: _todoController,
            currentUser: currentUser,
            formKey: _formKey,
          ),
        );
      },
    );
  }
}

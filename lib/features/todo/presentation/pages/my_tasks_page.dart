import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/auth/presentation/bloc/homepage/bloc/homepage_bloc.dart';
import 'package:taskaroo/features/auth/presentation/widgets/custom_drawer.dart';
import 'package:taskaroo/features/auth/presentation/widgets/sync_button.dart';
import 'package:taskaroo/features/auth/presentation/widgets/toggle_theme_switch.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/my_task_widgets/todo.dart';
import 'package:taskaroo/features/todo/presentation/widgets/my_task_widgets/add_alert_box.dart';

class MyTasksPage extends StatefulWidget {
  const MyTasksPage({super.key});

  @override
  State<MyTasksPage> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<MyTasksPage>
    with WidgetsBindingObserver {
  final currentUser = FirebaseAuth.instance.currentUser;
  final _todoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncWithCloud();
  }

  @override
  void dispose() {
    _todoController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncWithCloud();
    }
  }

  void _syncWithCloud() {
    context.read<TodoBloc>().add(PushLocalTodosToCloudEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        actions: [
          Row(children: [SyncButton(), ToggleThemeSwitch()]),
        ],
      ),
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

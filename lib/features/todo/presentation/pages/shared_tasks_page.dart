import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/auth/presentation/widgets/sync_button.dart';
import 'package:taskaroo/features/auth/presentation/widgets/toggle_theme_switch.dart';
import 'package:taskaroo/features/todo/presentation/bloc/shared_todo_bloc/shared_todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/shared_todo_widgets/shared_todo_list_view.dart';

class SharedTasksPage extends StatefulWidget {
  const SharedTasksPage({super.key});

  @override
  State<SharedTasksPage> createState() => _SharedTasksPageState();
}

class _SharedTasksPageState extends State<SharedTasksPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncToCloud();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncToCloud();
    }
  }

  void _syncToCloud() {
    context.read<SharedTodoBloc>().add(PushLocalSharedTodosToCloud());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SharedTodoBloc, SharedTodoState>(
      listener: (context, state) {
        if (state is LoadSharedTodoListSuccessState) {
          logger.d(
            'Data received in shared list --- ${state.sharedTodoList.length}',
          );
        } else if (state is LoadSharedTodoListFailedState) {
          logger.e('Failed to fetch shared list');
        }
      },
      builder: (context, state) {
        if (state is LoadSharedTodoListSuccessState) {
          final sharedTodoList = state.sharedTodoList;
          if (sharedTodoList.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 68,
                actions: [
                  Row(children: [SyncButton(), ToggleThemeSwitch()]),
                ],
              ),
              body: const Center(child: Text('No shared tasks')),
            );
          }
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 68,
              actions: [
                Row(children: [SyncButton(), ToggleThemeSwitch()]),
              ],
            ),
            body: SharedTodo(sharedTodoList: state.sharedTodoList),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 68,
              actions: [
                Row(children: [SyncButton(), ToggleThemeSwitch()]),
              ],
            ),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }
      },
    );
  }
}

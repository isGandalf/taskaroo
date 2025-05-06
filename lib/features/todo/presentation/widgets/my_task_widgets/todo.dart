import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/my_task_widgets/todo_list_view.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      listenWhen: (previous, current) => current is TodoActionState,
      buildWhen: (previous, current) => current is! TodoActionState,
      listener: (context, state) {
        if (state is AddTodoSucessState) {
          showCustomSnackbar(context, 'Task added', Colors.green.shade700);
          //logger.d(state.runtimeType);
        } else if (state is AddTodoFailedState) {
          showCustomSnackbar(
            context,
            'Failed to add task',
            Colors.red.shade700,
          );
          //logger.d(state.runtimeType);
        } else if (state is SyncingState) {
        } else if (state is UpdateTodoFailedState) {
          showCustomSnackbar(
            context,
            'Failed to update task',
            Colors.red.shade700,
          );
          //logger.d(state.runtimeType);
        } else if (state is DeleteTodoSucessState) {
          showCustomSnackbar(context, 'task deleted', Colors.red.shade700);
        } else if (state is DeleteTodoFailedState) {
          showCustomSnackbar(
            context,
            'Failed to delete task',
            Colors.red.shade700,
          );
          //logger.d(state.runtimeType);
        }
      },
      builder: (context, state) {
        if (state is SyncingState) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Syncing...'),
              ],
            ),
          );
        } else if (state is LoadTodoListSuccessState) {
          final todos = state.todoList;
          //print(' load todo state -------- ${todos.first.content}');
          if (todos.isEmpty) {
            logger.d('Todo list is empty');
            return const Center(child: Text('No tasks yet'));
          }
          return TodoListView(todos: todos);
        } else if (state is LoadTodoListFailedState) {
          return const Center(child: Text('Unable to fetch any task'));
        }
        //logger.d('Unexpected error ${state.runtimeType}');
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}

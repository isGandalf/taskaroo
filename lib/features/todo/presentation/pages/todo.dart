import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/core/theme/light.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/todo_list_view.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(FetchTodoListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      listenWhen: (previous, current) => current is TodoActionState,
      buildWhen: (previous, current) => current is! TodoActionState,
      listener: (context, state) {
        logger.d('listner: ${state.runtimeType}');
        if (state is AddTodoSucessState) {
          showCustomSnackbar(context, 'Todo added', Colors.green.shade700);
          //logger.d(state.runtimeType);
        } else if (state is AddTodoFailedState) {
          showCustomSnackbar(
            context,
            'Failed to add todo',
            Colors.red.shade700,
          );
          //logger.d(state.runtimeType);
        } else if (state is UpdateTodoSucessState) {
        } else if (state is UpdateTodoFailedState) {
          showCustomSnackbar(
            context,
            'Failed to update todo',
            Colors.red.shade700,
          );
          //logger.d(state.runtimeType);
        } else if (state is DeleteTodoSucessState) {
          showCustomSnackbar(context, 'Todo deleted', Colors.red.shade700);
        } else if (state is DeleteTodoFailedState) {
          showCustomSnackbar(
            context,
            'Failed to delete todo',
            Colors.red.shade700,
          );
          //logger.d(state.runtimeType);
        }
      },
      builder: (context, state) {
        logger.d('Builder: ${state.runtimeType}');
        if (state is LoadTodoListState) {
          final todos = state.todoList;
          if (todos.isEmpty) {
            //logger.d('Todo list is empty');
            return const Center(child: Text('No todos yet'));
          }
          return TodoListView(todos: todos);
        } else if (state is LoadTodoListFailedState) {
          return const Center(child: Text('Unable to fetch any todos'));
        }
        //logger.d('Unexpected error ${state.runtimeType}');
        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }
}

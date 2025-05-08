import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/bloc/shared_todo_bloc/shared_todo_bloc.dart';

class SyncButton extends StatelessWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            context.read<TodoBloc>().add(PushLocalTodosToCloudEvent());
            context.read<SharedTodoBloc>().add(PushLocalSharedTodosToCloud());
          },
          icon: Icon(Icons.refresh_rounded),
        ),
        Text('Sync', style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

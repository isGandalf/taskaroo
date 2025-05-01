import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/core/theme/theme_provider.dart';
import 'package:taskaroo/features/todo/presentation/bloc/todo_bloc.dart';

class SyncButton extends StatelessWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            context.read<TodoBloc>().add(PushLocalTodosToCloudEvent());
          },
          icon: Icon(Icons.refresh_rounded),
        ),
        Text(
          context.read<ThemeProvider>().isLightTheme ? 'Sync' : 'Sync',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

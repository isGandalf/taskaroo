import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/widgets/confirmation_dialog.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.todoItem});

  final ToDoEntity todoItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return ConfirmationDialog(
                todoItem: todoItem,
                onTapYes: () {
                  context.read<TodoBloc>().add(
                    DeleteTodoButtonPressedEvent(id: todoItem.id),
                  );
                  Navigator.of(context).pop();
                },
                onTapNo: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(color: Colors.red.shade700),
          child: const Center(child: Icon(Icons.delete, color: Colors.white)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/widgets/delete_button.dart';
import 'package:taskaroo/features/todo/presentation/widgets/edit_button.dart';

class TodoItemOptions extends StatelessWidget {
  const TodoItemOptions({super.key, required this.todoItem});

  final ToDoEntity todoItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Edit
        EditButton(todoItem: todoItem),

        // Delete todo
        DeleteButton(todoItem: todoItem),
      ],
    );
  }
}

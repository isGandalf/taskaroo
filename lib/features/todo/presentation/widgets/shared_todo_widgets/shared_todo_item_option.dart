import 'package:flutter/material.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/widgets/common/edit_button.dart';

class SharedTodoItemOption extends StatelessWidget {
  const SharedTodoItemOption({super.key, required this.todoItem});

  final ToDoEntity todoItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Edit
        EditButton(todoItem: todoItem),
      ],
    );
  }
}

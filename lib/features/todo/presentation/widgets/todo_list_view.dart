import 'package:flutter/material.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/widgets/todo_tile.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key, required this.todos});

  final List<ToDoEntity> todos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todoItem = todos[index];
        return TodoTile(todoItem: todoItem);
      },
    );
  }
}

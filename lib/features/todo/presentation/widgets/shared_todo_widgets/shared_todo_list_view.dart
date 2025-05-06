import 'package:flutter/material.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/widgets/common/todo_tile.dart';

class SharedTodo extends StatelessWidget {
  final List<ToDoEntity> sharedTodoList;
  const SharedTodo({super.key, required this.sharedTodoList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sharedTodoList.length,
      itemBuilder: (context, index) {
        final todoItem = sharedTodoList[index];
        return TodoTile(todoItem: todoItem);
      },
    );
  }
}

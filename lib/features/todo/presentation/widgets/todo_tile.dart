import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/todo_item_options.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todoItem});

  final ToDoEntity todoItem;
  final Color constantColor = Colors.white;

  void _checkTodoStatusToggle(bool value, BuildContext context) {
    context.read<TodoBloc>().add(
      ToggleTodoEvent(
        id: todoItem.id,
        userId: todoItem.userId,
        content: todoItem.content,
        createdAt: todoItem.createdAt,
        updatedAt: DateTime.now(),
        isCompleted: todoItem.isCompleted,
      ),
    );
  }

  Color colorOnCompletion(BuildContext context) {
    return todoItem.isCompleted
        ? Colors.green
        : Theme.of(context).colorScheme.tertiary;
  }

  Color _tileTextColorOnCompletion(BuildContext context, bool isCompleted) {
    return Theme.of(context).brightness == Brightness.light
        ? !isCompleted
            ? Colors.black
            : constantColor
        : constantColor;
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMMEEEEd().add_jm().format(todoItem.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        collapsedBackgroundColor: colorOnCompletion(context),
        backgroundColor: colorOnCompletion(context),
        textColor: _tileTextColorOnCompletion(context, todoItem.isCompleted),
        collapsedTextColor: _tileTextColorOnCompletion(
          context,
          todoItem.isCompleted,
        ),
        iconColor: _tileTextColorOnCompletion(context, todoItem.isCompleted),
        collapsedIconColor: _tileTextColorOnCompletion(
          context,
          todoItem.isCompleted,
        ),

        // checkbox
        leading: Checkbox(
          value: todoItem.isCompleted,
          onChanged:
              (_) => _checkTodoStatusToggle(todoItem.isCompleted, context),
          activeColor: Colors.green,
          checkColor: constantColor,
        ),

        // content
        title: Text(todoItem.content),
        subtitle: Text(date),

        // more options
        children: [TodoItemOptions(todoItem: todoItem)],
      ),
    );
  }
}

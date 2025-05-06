import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/bloc/shared_todo_bloc/shared_todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/my_task_widgets/add_action_button.dart';
import 'package:taskaroo/features/todo/presentation/widgets/my_task_widgets/todo_item_options.dart';
import 'package:taskaroo/features/todo/presentation/widgets/shared_todo_widgets/shared_todo_item_option.dart';

class TodoTile extends StatefulWidget {
  const TodoTile({super.key, required this.todoItem});

  final ToDoEntity todoItem;

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  final Color constantColor = Colors.white;
  final _shareEmailController = TextEditingController();

  void _checkTodoStatusToggle(
    bool value,
    BuildContext context,
    bool isOwnedByMe,
  ) {
    if (isOwnedByMe) {
      context.read<TodoBloc>().add(ToggleTodoEvent(id: widget.todoItem.id));
    } else {
      context.read<SharedTodoBloc>().add(
        ToggleSharedTodoEvent(id: widget.todoItem.id),
      );
    }
  }

  Color colorOnCompletion(BuildContext context) {
    return widget.todoItem.isCompleted
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
    final isOwnedByMe =
        FirebaseAuth.instance.currentUser?.uid == widget.todoItem.userId;

    final date = DateFormat.MEd().add_jm().format(widget.todoItem.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        collapsedBackgroundColor: colorOnCompletion(context),
        backgroundColor: colorOnCompletion(context),
        textColor: _tileTextColorOnCompletion(
          context,
          widget.todoItem.isCompleted,
        ),
        collapsedTextColor: _tileTextColorOnCompletion(
          context,
          widget.todoItem.isCompleted,
        ),
        iconColor: _tileTextColorOnCompletion(
          context,
          widget.todoItem.isCompleted,
        ),
        collapsedIconColor: _tileTextColorOnCompletion(
          context,
          widget.todoItem.isCompleted,
        ),

        // checkbox
        leading: Checkbox(
          value: widget.todoItem.isCompleted,
          onChanged:
              (_) => _checkTodoStatusToggle(
                widget.todoItem.isCompleted,
                context,
                isOwnedByMe,
              ),
          activeColor: Colors.green,
          checkColor: constantColor,
        ),

        // content
        title:
            isOwnedByMe
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(widget.todoItem.content),
                    ),
                    IconButton(
                      onPressed: () {
                        _shareTask(context);
                      },
                      icon: Icon(
                        Icons.share,
                        color:
                            widget.todoItem.isShared
                                ? Colors.blue.shade700
                                : Colors.white,
                      ),
                    ),
                  ],
                )
                : Text(widget.todoItem.content),
        subtitle:
            isOwnedByMe
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date),
                    if (widget.todoItem.sharedWith != null)
                      Text('Shared with: ${widget.todoItem.sharedWith}'),
                  ],
                )
                : Text(date),

        // more options
        children: [
          isOwnedByMe
              ? TodoItemOptions(todoItem: widget.todoItem)
              : SharedTodoItemOption(todoItem: widget.todoItem),
        ],
      ),
    );
  }

  Future<dynamic> _shareTask(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.zero,
          title: Text('Share'),
          content: TextField(controller: _shareEmailController),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AddActionButton(
                  onTap: () => Navigator.of(context).pop(),
                  backgroundColor: Colors.red.shade700,
                  icon: Icons.close,
                  radius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                ),
                AddActionButton(
                  onTap: () {
                    context.read<SharedTodoBloc>().add(
                      SharedTodoButtonPressedEvent(
                        id: widget.todoItem.id,
                        email: _shareEmailController.text,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.green.shade700,
                  icon: Icons.check,
                  radius: BorderRadius.only(bottomRight: Radius.circular(10)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

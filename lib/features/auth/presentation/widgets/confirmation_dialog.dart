import 'package:flutter/material.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/widgets/my_task_widgets/custom_dialog_button.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.todoItem,
    required this.onTapYes,
    required this.onTapNo,
  });

  final ToDoEntity? todoItem;
  final VoidCallback onTapYes;
  final VoidCallback onTapNo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
        child: Text(
          'Are you sure?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.white,
      actionsPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomDialogButton(
              labelText: 'Yes',
              onTap: onTapYes,
              backgroundColor: Colors.red.shade700,

              radius: BorderRadius.only(bottomLeft: Radius.circular(10)),
            ),
            CustomDialogButton(
              labelText: 'No',
              onTap: onTapNo,
              backgroundColor: Colors.blue.shade700,

              radius: BorderRadius.only(bottomRight: Radius.circular(10)),
            ),
          ],
        ),
      ],
    );
  }
}

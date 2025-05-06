import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_fields.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/my_task_widgets/add_action_button.dart';

class AddAlertBox extends StatelessWidget {
  const AddAlertBox({
    super.key,
    required TextEditingController todoController,
    required GlobalKey<FormState> formKey,
    required this.currentUser,
  }) : _todoController = todoController,
       _formKey = formKey;

  final TextEditingController _todoController;
  final User? currentUser;
  final GlobalKey<FormState> _formKey;

  void addTodo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<TodoBloc>().add(
        AddNewToDoButtonPressedEvent(
          content: _todoController.text,
          userId: currentUser!.uid,
          createdAt: DateTime.now(),
        ),
      );
      _todoController.text = '';
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextFields.textFeilds(_todoController, 'Task'),
      actionsPadding: EdgeInsets.zero,
      title: Center(
        child: Text(
          'Add a task',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              onTap: () => addTodo(context),
              backgroundColor: Colors.green.shade700,
              icon: Icons.check,
              radius: BorderRadius.only(bottomRight: Radius.circular(10)),
            ),
          ],
        ),
      ],
    );
  }
}

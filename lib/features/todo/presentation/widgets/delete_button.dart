import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/delete_action_button.dart';

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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DeleteActionButton(
                        labelText: 'Yes',
                        onTap: () {
                          context.read<TodoBloc>().add(
                            DeleteTodoButtonPressedEvent(todo: todoItem),
                          );
                          Navigator.of(context).pop();
                        },
                        backgroundColor: Colors.red.shade700,

                        radius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      DeleteActionButton(
                        labelText: 'No',
                        onTap: () => Navigator.of(context).pop(),
                        backgroundColor: Colors.blue.shade700,

                        radius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
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

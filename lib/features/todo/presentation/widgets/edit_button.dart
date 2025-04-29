import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/auth/presentation/widgets/text_fields.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/widgets/edit_action_button.dart';

class EditButton extends StatelessWidget {
  final ToDoEntity todoItem;

  const EditButton({super.key, required this.todoItem});

  @override
  Widget build(BuildContext context) {
    final TextEditingController todoContent = TextEditingController(
      text: todoItem.content,
    );
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Center(
                  child: Text(
                    'Update',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                // backgroundColor:
                //     Theme.of(context).brightness == Brightness.dark
                //         ? Colors.grey.shade900
                //         : Colors.white,
                actionsPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: TextFields.textFeilds(todoContent, 'Todo'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      EditActionButton(
                        icon: Icons.close,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: Colors.red.shade700,

                        radius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      EditActionButton(
                        icon: Icons.check,
                        onTap: () {
                          logger.d('From ui: ${todoItem.createdAt}');
                          context.read<TodoBloc>().add(
                            EditTodoButtonPressedEvent(
                              userId: todoItem.userId,
                              content: todoContent.text,
                              isCompleted: todoItem.isCompleted,
                              id: todoItem.id,
                              createdAt: todoItem.createdAt,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
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
          decoration: BoxDecoration(color: Colors.blue.shade700),
          child: const Center(child: Icon(Icons.edit, color: Colors.white)),
        ),
      ),
    );
  }
}

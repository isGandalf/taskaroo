import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';
import 'package:taskaroo/features/auth/presentation/bloc/homepage/bloc/homepage_bloc.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/bloc/shared_todo_bloc/shared_todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/pages/my_tasks_page.dart';
import 'package:taskaroo/features/todo/presentation/pages/shared_tasks_page.dart';

class Homepage extends StatefulWidget {
  final UserEntity userEntity;
  final String userId;

  const Homepage({super.key, required this.userEntity, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentPage = 0;
  final List<Widget> pages = [MyTasksPage(), SharedTasksPage()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              HomepageBloc()
                ..add(LoadHomepageEvent(userEntity: widget.userEntity)),
      child: Scaffold(
        body: IndexedStack(index: currentPage, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              label: 'My tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared),
              label: 'Shared tasks',
            ),
          ],
          iconSize: 35,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: Colors.blue,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
            if (value == 1) {
              context.read<SharedTodoBloc>().add(
                FetchSharedTodoFromCloudEvent(),
              );
            } else {
              context.read<TodoBloc>().add(PushLocalTodosToCloudEvent());
            }
          },
          currentIndex: currentPage,
        ),
      ),
    );
  }
}

part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

// this event will be triggered to fetch all todos
final class FetchTodoListEvent extends TodoEvent {}

// event triggered when add todo button is pressed
final class AddNewToDoButtonPressedEvent extends TodoEvent {
  final String userId;
  final String content;
  final bool isCompleted;

  AddNewToDoButtonPressedEvent({
    required this.userId,
    required this.content,
    this.isCompleted = false,
  });
}

// event triggered when exsisting todo is updated, editing the todo content
final class EditTodoButtonPressedEvent extends TodoEvent {
  final int id;
  final String userId;
  final String content;
  final bool isCompleted;

  EditTodoButtonPressedEvent({
    required this.id,
    required this.userId,
    required this.content,
    required this.isCompleted,
  });
}

// event triggered when delete button is pressed
final class DeleteTodoButtonPressedEvent extends TodoEvent {
  final ToDoEntity todo;

  DeleteTodoButtonPressedEvent({required this.todo});
}

// event triggered when todo needs to be marked completed
final class ToggleTodoEvent extends TodoEvent {
  final int id;
  final String userId;
  final String content;
  final bool isCompleted;
  ToggleTodoEvent({
    required this.id,
    required this.userId,
    required this.content,
    required this.isCompleted,
  });
}

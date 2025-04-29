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
  final DateTime createdAt;

  AddNewToDoButtonPressedEvent({
    required this.userId,
    required this.content,
    required this.createdAt,
    this.isCompleted = false,
  });
}

// event triggered when exsisting todo is updated, editing the todo content
final class EditTodoButtonPressedEvent extends TodoEvent {
  final int id;
  final String userId;
  final String content;
  final DateTime createdAt;
  final bool isCompleted;

  EditTodoButtonPressedEvent({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;

  ToggleTodoEvent({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
  });
}

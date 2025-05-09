part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

// this event will be triggered on each app run to upload all data from local to cloud
final class PushLocalTodosToCloudEvent extends TodoEvent {}

// this event will be triggered to download cloud data to local
final class FetchTodosFromCloudEvent extends TodoEvent {}

// this event will be triggered to fetch all todos from local
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
  final String content;

  EditTodoButtonPressedEvent({required this.id, required this.content});
}

// event triggered when delete button is pressed
final class DeleteTodoButtonPressedEvent extends TodoEvent {
  final int id;

  DeleteTodoButtonPressedEvent({required this.id});
}

// event triggered when todo needs to be marked completed
final class ToggleTodoEvent extends TodoEvent {
  final int id;

  ToggleTodoEvent({required this.id});
}

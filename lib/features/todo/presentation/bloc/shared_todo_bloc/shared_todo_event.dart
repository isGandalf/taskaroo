part of 'shared_todo_bloc.dart';

@immutable
sealed class SharedTodoEvent {}

final class FetchSharedTodoFromCloudEvent extends SharedTodoEvent {}

final class FetchSharedTodoFromLocalEvent extends SharedTodoEvent {}

final class PushLocalSharedTodosToCloud extends SharedTodoEvent {}

final class UpdateSharedTodoEvent extends SharedTodoEvent {
  final int id;
  final String content;

  UpdateSharedTodoEvent({required this.id, required this.content});
}

final class ToggleSharedTodoEvent extends SharedTodoEvent {
  final int id;

  ToggleSharedTodoEvent({required this.id});
}

final class SharedTodoButtonPressedEvent extends SharedTodoEvent {
  final int id;
  final String email;

  SharedTodoButtonPressedEvent({required this.id, required this.email});
}

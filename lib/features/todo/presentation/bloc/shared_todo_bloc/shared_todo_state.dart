part of 'shared_todo_bloc.dart';

@immutable
sealed class SharedTodoState {}

final class SharedTodoInitial extends SharedTodoState {}

final class SharedTodoActionState extends SharedTodoState {}

// fetch shared todo from cloud
final class LoadSharedTodoFromCloudSuccessState extends SharedTodoState {}

final class LoadSharedTodoFromCloudFailedState extends SharedTodoState {}

// fetch shared todos from local
final class LoadSharedTodoListSuccessState extends SharedTodoState {
  final List<ToDoEntity> sharedTodoList;

  LoadSharedTodoListSuccessState({required this.sharedTodoList});
}

final class LoadSharedTodoListFailedState extends SharedTodoState {}

// share todo
final class ShareDone extends SharedTodoActionState {}

final class ShareFailed extends SharedTodoActionState {}

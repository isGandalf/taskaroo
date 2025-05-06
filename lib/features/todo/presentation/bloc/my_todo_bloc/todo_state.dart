part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

// initial default state
final class TodoInitial extends TodoState {}

// this class will be used for any action performed on the UI that effects the todolist
final class TodoActionState extends TodoState {}

// S T A N D A R D    S T A T E S - standard todo state which will be called
// after every action taken on the todo list
final class PushLocalTodosToCloudSuccessState extends TodoState {}

final class PushLocalTodosToCloudFailedState extends TodoState {}

final class SyncingState extends TodoState {}

// fetch todos from cloud success state
final class LoadTodoListFromCloudSuccessState extends TodoState {}

// fetch todos from cloud success state
final class LoadTodoListFromCloudFailedState extends TodoState {}

// fetch from local
final class LoadTodoListSuccessState extends TodoState {
  final List<ToDoEntity> todoList;

  LoadTodoListSuccessState({required this.todoList});
}

// fetch failed state
final class LoadTodoListFailedState extends TodoState {}

/* A C T I O N    S T A T E S */
// Add todo success state
final class AddTodoSucessState extends TodoActionState {}

final class AddTodoFailedState extends TodoActionState {}

// update todo success state
final class UpdateTodoSucessState extends TodoActionState {}

final class UpdateTodoFailedState extends TodoActionState {}

// toto delete success state
final class DeleteTodoSucessState extends TodoActionState {}

final class DeleteTodoFailedState extends TodoActionState {}

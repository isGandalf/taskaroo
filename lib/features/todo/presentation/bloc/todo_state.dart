part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

// initial default state
final class TodoInitial extends TodoState {}

// this class will be used for any action performed on the UI that effects the todolist
final class TodoActionState extends TodoState {}

// S T A N D A R D    S T A T E S

// standard todo state which will be called after every action taken on the todo list
final class LoadTodoListState extends TodoState {
  final List<ToDoEntity> todoList;

  LoadTodoListState({required this.todoList});
}

// fetch failed state
final class LoadTodoListFailedState extends TodoState {}

/* A C T I O N    S T A T E S */
// Add todo success state
final class AddTodoSucessState extends TodoActionState {}

// Add todo failed state
final class AddTodoFailedState extends TodoActionState {}

// update todo success state
final class UpdateTodoSucessState extends TodoActionState {}

// update todo failed state
final class UpdateTodoFailedState extends TodoActionState {}

// toto delete success state
final class DeleteTodoSucessState extends TodoActionState {}

// todo delete failed state
final class DeleteTodoFailedState extends TodoActionState {}

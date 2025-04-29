import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dart_either/dart_either.dart';

import 'package:meta/meta.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';

import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/usecase/todo_usecases.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoUsecases todoUsecases;

  TodoBloc(this.todoUsecases) : super(TodoInitial()) {
    on<FetchTodoListEvent>(fetchTodoListEvent);
    on<AddNewToDoButtonPressedEvent>(addNewToDoButtonPressedEvent);
    on<ToggleTodoEvent>(toggleTodoEvent);
    on<DeleteTodoButtonPressedEvent>(deleteTodoButtonPressedEvent);
    on<EditTodoButtonPressedEvent>(editTodoButtonPressedEvent);
  }

  FutureOr<void> fetchTodoListEvent(
    FetchTodoListEvent event,
    Emitter<TodoState> emit,
  ) async {
    final todoList = await todoUsecases.fetchToDos();

    return todoList.fold(
      ifLeft: (failure) {
        logger.d('Fetch failed');
        emit(LoadTodoListFailedState());
      },
      ifRight: (list) {
        logger.d('Fetch success');
        emit(LoadTodoListState(todoList: list));
      },
    );
  }

  FutureOr<void> addNewToDoButtonPressedEvent(
    AddNewToDoButtonPressedEvent event,
    Emitter<TodoState> emit,
  ) async {
    final newTodo = ToDoEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      content: event.content,
      userId: event.userId,
      isCompleted: false,
      createdAt: event.createdAt,
    );

    final newTodoAdded = await todoUsecases.addTodo(newTodo);
    final todoList = await todoUsecases.fetchToDos();
    final syncToCloud = await todoUsecases.cloudSync(newTodo);

    return newTodoAdded.fold(
      ifLeft: (failure) async {
        logger.d(state);
        emit(AddTodoFailedState());
      },

      ifRight: (_) async {
        emit(AddTodoSucessState());
        syncToCloud.fold(
          ifLeft: (failure) => emit(CloudSyncSuccessState()),
          ifRight: (_) => emit(CloudSyncSuccessState()),
        );
        todoList.fold(
          ifLeft: (_) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListState(todoList: list)),
        );
      },
    );
  }

  FutureOr<void> toggleTodoEvent(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    logger.d(' Event = ${event.isCompleted}');
    final getTodo = ToDoEntity(
      id: event.id,
      content: event.content,
      userId: event.userId,
      isCompleted: event.isCompleted,
      createdAt: event.createdAt,
      updatedAt: event.updatedAt,
    );
    final todoUpdated = await todoUsecases.toggleCompletion(getTodo);
    final todoList = await todoUsecases.fetchToDos();

    return todoUpdated.fold(
      ifLeft: (failure) => emit(UpdateTodoFailedState()),
      ifRight: (_) {
        emit(UpdateTodoSucessState());
        todoList.fold(
          ifLeft: (_) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListState(todoList: list)),
        );
      },
    );
  }

  FutureOr<void> deleteTodoButtonPressedEvent(
    DeleteTodoButtonPressedEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await todoUsecases.deleteTodo(event.todo);
    final todoList = await todoUsecases.fetchToDos();

    return result.fold(
      ifLeft: (failure) => emit(DeleteTodoFailedState()),
      ifRight: (_) async {
        logger.d('Delete todo success state');
        emit(DeleteTodoSucessState());
        todoList.fold(
          ifLeft: (failure) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListState(todoList: list)),
        );
      },
    );
  }

  FutureOr<void> editTodoButtonPressedEvent(
    EditTodoButtonPressedEvent event,
    Emitter<TodoState> emit,
  ) async {
    final newTodo = ToDoEntity(
      id: event.id,
      content: event.content,
      userId: event.userId,
      isCompleted: false,
      createdAt: event.createdAt,
    );

    final newTodoAdded = await todoUsecases.updateTodo(newTodo);
    final todoList = await todoUsecases.fetchToDos();

    return newTodoAdded.fold(
      ifLeft: (failure) async {
        emit(UpdateTodoFailedState());
      },

      ifRight: (_) async {
        emit(UpdateTodoSucessState());
        todoList.fold(
          ifLeft: (_) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListState(todoList: list)),
        );
      },
    );
  }
}

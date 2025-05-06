import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dart_either/dart_either.dart';
import 'package:meta/meta.dart';

import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/usecase/todo_usecases.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoUsecases todoUsecases;

  TodoBloc(this.todoUsecases) : super(TodoInitial()) {
    on<PushLocalTodosToCloudEvent>(pushLocalTodosToCloud);
    on<FetchTodosFromCloudEvent>(fetchTodosFromCloudEvent);
    on<FetchTodoListEvent>(fetchTodoListEvent);
    on<AddNewToDoButtonPressedEvent>(addNewToDoButtonPressedEvent);
    on<ToggleTodoEvent>(toggleTodoEvent);
    on<DeleteTodoButtonPressedEvent>(deleteTodoButtonPressedEvent);
    on<EditTodoButtonPressedEvent>(editTodoButtonPressedEvent);
  }

  // push local data to cloud
  FutureOr<void> pushLocalTodosToCloud(
    PushLocalTodosToCloudEvent event,
    Emitter<TodoState> emit,
  ) async {
    emit(SyncingState());
    // syncing state
    try {
      await todoUsecases.pushLocalTodosToCloud();

      // fetch from cloud
      await todoUsecases.fetchTodoFromCloud();

      // save to local
      final todolist = await todoUsecases.fetchToDos();
      return todolist.fold(
        ifLeft: (failure) => emit(LoadTodoListFailedState()),
        ifRight: (list) => emit(LoadTodoListSuccessState(todoList: list)),
      );
    } on Exception catch (e) {
      logger.e('Error during sync: $e');
      emit(LoadTodoListFailedState());
    }
  }

  // save cloud data to local
  FutureOr<void> fetchTodosFromCloudEvent(
    FetchTodosFromCloudEvent event,
    Emitter<TodoState> emit,
  ) async {
    logger.d('Fetching data from cloud...');
    final todoList = await todoUsecases.fetchTodoFromCloud();
    return todoList.fold(
      ifLeft: (failure) {
        logger.e('In bloc: ${failure.error}');
        emit(LoadTodoListFromCloudFailedState());
      },
      ifRight: (todoList) {
        logger.d('Bloc: Fetch success from cloud');
        emit(LoadTodoListFromCloudSuccessState());
      },
    );
  }

  FutureOr<void> fetchTodoListEvent(
    FetchTodoListEvent event,
    Emitter<TodoState> emit,
  ) async {
    final todoList = await todoUsecases.fetchToDos();

    return todoList.fold(
      ifLeft: (failure) {
        logger.d('Fetch bloc operation failed');
        emit(LoadTodoListFailedState());
      },
      ifRight: (list) {
        logger.d('Fetch bloc operation success');
        emit(LoadTodoListSuccessState(todoList: list));
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
      createdAt: event.createdAt,
    );

    final newTodoAdded = await todoUsecases.addTodo(newTodo);
    final todoList = await todoUsecases.fetchToDos();
    // final syncToCloud = await todoUsecases.cloudSync(newTodo);

    return newTodoAdded.fold(
      ifLeft: (failure) async {
        logger.d(state);
        emit(AddTodoFailedState());
      },

      ifRight: (_) async {
        emit(AddTodoSucessState());
        todoList.fold(
          ifLeft: (_) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListSuccessState(todoList: list)),
        );
      },
    );
  }

  FutureOr<void> toggleTodoEvent(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final todoUpdated = await todoUsecases.toggleCompletion(event.id);
    final todoList = await todoUsecases.fetchToDos();

    return todoUpdated.fold(
      ifLeft: (failure) => emit(UpdateTodoFailedState()),
      ifRight: (_) {
        emit(UpdateTodoSucessState());
        todoList.fold(
          ifLeft: (_) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListSuccessState(todoList: list)),
        );
      },
    );
  }

  FutureOr<void> deleteTodoButtonPressedEvent(
    DeleteTodoButtonPressedEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await todoUsecases.deleteTodo(event.id);
    final todoList = await todoUsecases.fetchToDos();

    return result.fold(
      ifLeft: (failure) => emit(DeleteTodoFailedState()),
      ifRight: (_) async {
        logger.d('Delete todo success state');
        emit(DeleteTodoSucessState());
        todoList.fold(
          ifLeft: (failure) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListSuccessState(todoList: list)),
        );
      },
    );
  }

  FutureOr<void> editTodoButtonPressedEvent(
    EditTodoButtonPressedEvent event,
    Emitter<TodoState> emit,
  ) async {
    final newTodoAdded = await todoUsecases.updateTodo(event.id, event.content);
    final todoList = await todoUsecases.fetchToDos();

    return newTodoAdded.fold(
      ifLeft: (failure) async {
        emit(UpdateTodoFailedState());
      },

      ifRight: (_) async {
        emit(UpdateTodoSucessState());
        todoList.fold(
          ifLeft: (_) => emit(LoadTodoListFailedState()),
          ifRight: (list) => emit(LoadTodoListSuccessState(todoList: list)),
        );
      },
    );
  }
}

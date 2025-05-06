import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/repository/shared_todo_domain_repository.dart';

part 'shared_todo_event.dart';
part 'shared_todo_state.dart';

class SharedTodoBloc extends Bloc<SharedTodoEvent, SharedTodoState> {
  final SharedTodoDomainRepository sharedTodoDomainRepository;

  SharedTodoBloc(this.sharedTodoDomainRepository) : super(SharedTodoInitial()) {
    on<FetchSharedTodoFromCloudEvent>(fetchSharedTodoFromCloudEvent);
    on<FetchSharedTodoFromLocalEvent>(fetchSharedTodoFromLocalEvent);
    on<UpdateSharedTodoEvent>(updateSharedTodoEvent);
    on<ToggleSharedTodoEvent>(toggleSharedTodoEvent);
    on<PushLocalSharedTodosToCloud>(pushLocalSharedTodosToCloud);
    on<SharedTodoButtonPressedEvent>(sharedTodoButtonPressedEvent);
  }

  FutureOr<void> fetchSharedTodoFromCloudEvent(
    FetchSharedTodoFromCloudEvent event,
    Emitter<SharedTodoState> emit,
  ) async {
    try {
      await sharedTodoDomainRepository.fetchSharedTodosFromCloud();
      final list = await sharedTodoDomainRepository.fetchSharedTodo();
      emit(LoadSharedTodoFromCloudSuccessState());
      return list.fold(
        ifLeft: (failure) => emit(LoadSharedTodoListFailedState()),
        ifRight:
            (list) =>
                emit(LoadSharedTodoListSuccessState(sharedTodoList: list)),
      );
    } catch (e) {
      emit(LoadSharedTodoFromCloudFailedState());
    }
  }

  FutureOr<void> fetchSharedTodoFromLocalEvent(
    FetchSharedTodoFromLocalEvent event,
    Emitter<SharedTodoState> emit,
  ) async {
    try {
      final list = await sharedTodoDomainRepository.fetchSharedTodo();
      return list.fold(
        ifLeft: (failure) => emit(LoadSharedTodoListFailedState()),
        ifRight:
            (list) =>
                emit(LoadSharedTodoListSuccessState(sharedTodoList: list)),
      );
    } catch (e) {
      emit(LoadSharedTodoListFailedState());
    }
  }

  FutureOr<void> updateSharedTodoEvent(
    UpdateSharedTodoEvent event,
    Emitter<SharedTodoState> emit,
  ) async {
    try {
      await sharedTodoDomainRepository.updateSharedTodo(
        event.id,
        event.content,
      );
      final list = await sharedTodoDomainRepository.fetchSharedTodo();
      return list.fold(
        ifLeft: (failure) => emit(LoadSharedTodoListFailedState()),
        ifRight:
            (list) =>
                emit(LoadSharedTodoListSuccessState(sharedTodoList: list)),
      );
    } catch (e) {
      emit(LoadSharedTodoListFailedState());
    }
  }

  FutureOr<void> toggleSharedTodoEvent(
    ToggleSharedTodoEvent event,
    Emitter<SharedTodoState> emit,
  ) async {
    try {
      await sharedTodoDomainRepository.toggleSharedTodo(event.id);
      final list = await sharedTodoDomainRepository.fetchSharedTodo();
      return list.fold(
        ifLeft: (failure) => emit(LoadSharedTodoListFailedState()),
        ifRight:
            (list) =>
                emit(LoadSharedTodoListSuccessState(sharedTodoList: list)),
      );
    } catch (e) {
      emit(LoadSharedTodoListFailedState());
    }
  }

  FutureOr<void> pushLocalSharedTodosToCloud(
    PushLocalSharedTodosToCloud event,
    Emitter<SharedTodoState> emit,
  ) async {
    try {
      await sharedTodoDomainRepository.pushLocalSharedTodosToCloud();
      final list = await sharedTodoDomainRepository.fetchSharedTodo();
      return list.fold(
        ifLeft: (failure) => emit(LoadSharedTodoListFailedState()),
        ifRight:
            (list) =>
                emit(LoadSharedTodoListSuccessState(sharedTodoList: list)),
      );
    } catch (e) {
      emit(LoadSharedTodoListFailedState());
    }
  }

  FutureOr<void> sharedTodoButtonPressedEvent(
    SharedTodoButtonPressedEvent event,
    Emitter<SharedTodoState> emit,
  ) async {
    try {
      await sharedTodoDomainRepository.shareTodo(event.id, event.email);
      emit(ShareDone());
      final list = await sharedTodoDomainRepository.fetchSharedTodo();
      return list.fold(
        ifLeft: (failure) => emit(LoadSharedTodoListFailedState()),
        ifRight:
            (list) =>
                emit(LoadSharedTodoListSuccessState(sharedTodoList: list)),
      );
    } catch (e) {
      emit(ShareFailed());
      emit(LoadSharedTodoListFailedState());
    }
  }
}

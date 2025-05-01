/*

This class interacts with Bloc/UI to perform the CRUD actions on the Isar db and update UI

*/

import 'package:dart_either/dart_either.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/repository/todo_domain_repository.dart';

class TodoUsecases {
  final TodoDomainRepository todoDomainRepository;

  TodoUsecases({required this.todoDomainRepository});

  // push local data to cloud
  Future<Either<TodoFirebaseSync, void>> pushLocalTodosToCloud() async {
    try {
      final result = await todoDomainRepository.pushLocalTodosToCloud();
      return result.fold(
        ifLeft: (failure) => Left(TodoFirebaseSync(error: failure.error)),
        ifRight: (_) => Right(null),
      );
    } catch (e) {
      return Left(TodoFirebaseSync(error: '$e'));
    }
  }

  // fetch cloud data to local
  Future<Either<TodoFirebaseSync, void>> fetchTodoFromCloud() async {
    try {
      final result = await todoDomainRepository.fetchTodosFromCloud();

      return result.fold(
        ifLeft: (failure) => Left(TodoFirebaseSync(error: failure.error)),
        ifRight: (model) => Right(model),
      );
    } catch (e) {
      return Left(
        TodoFirebaseSync(error: 'Unexpected error when syncing from cloud: $e'),
      );
    }
  }

  // Fetch all todos
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>> fetchToDos() async {
    try {
      final todoFromIsar = await todoDomainRepository.fetchToDos();
      return todoFromIsar.fold(
        ifLeft: (failure) => Left(ToDoIsarFetchFailure(error: failure.error)),
        ifRight: (models) => Right(models),
      );
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: 'Unable to access todo list'));
    }
  }

  // add new todo
  Future<Either<ToDoIsarWriteFailure, void>> addTodo(ToDoEntity newTodo) async {
    try {
      final todoFromEntity = await todoDomainRepository.addToDo(newTodo);
      return todoFromEntity.fold(
        ifLeft: (failure) => Left(ToDoIsarWriteFailure(error: failure.error)),
        ifRight: (model) => Right(null),
      );
    } catch (e) {
      return Left(
        ToDoIsarWriteFailure(error: 'Unable to add to new todo : $e'),
      );
    }
  }

  // update an existing todo
  Future<Either<ToDoIsarUpdateFailure, void>> updateTodo(
    ToDoEntity newTodo,
  ) async {
    try {
      final todoFromEntity = await todoDomainRepository.updateToDo(newTodo);
      return todoFromEntity.fold(
        ifLeft: (failure) => Left(ToDoIsarUpdateFailure(error: failure.error)),
        ifRight: (model) => Right(model),
      );
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Unable to update todo : $e'));
    }
  }

  // delete todo
  Future<Either<TodoIsarDeleteFailure, void>> deleteTodo(
    ToDoEntity todo,
  ) async {
    try {
      final deleteTodo = await todoDomainRepository.deleteToDo(todo);
      return deleteTodo.fold(
        ifLeft: (failure) {
          logger.d('Delete failed: ${failure.error}');
          return Left(TodoIsarDeleteFailure(error: failure.error));
        },
        ifRight: (model) => Right(model),
      );
    } catch (e) {
      return Left(TodoIsarDeleteFailure(error: 'Unable to delete todo : $e'));
    }
  }

  // toggle completion
  Future<Either<ToDoIsarUpdateFailure, void>> toggleCompletion(
    ToDoEntity todo,
  ) async {
    try {
      final updatedTodo = await todoDomainRepository.toggleCompletionStatus(
        todo,
      );

      return updatedTodo.fold(
        ifLeft: (failure) => Left(ToDoIsarUpdateFailure(error: failure.error)),
        ifRight: (todo) => Right(todo),
      );
    } catch (e) {
      return Left(
        ToDoIsarUpdateFailure(error: 'Unable to update todo status : $e'),
      );
    }
  }

  // cloud update
  // Future<Either<TodoFirebaseSync, void>> cloudSync(ToDoEntity todo) async {
  //   try {
  //     final result = await todoDomainRepository.cloudUpdate(todo);
  //     return result.fold(
  //       ifLeft: (failure) => Left(TodoFirebaseSync(error: failure.error)),
  //       ifRight: (_) => Right(null),
  //     );
  //   } catch (e) {
  //     return Left(
  //       TodoFirebaseSync(error: 'Unexpected error store firestore data: $e'),
  //     );
  //   }
  // }
}

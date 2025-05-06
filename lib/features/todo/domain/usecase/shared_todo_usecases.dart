/*

This class interacts with Bloc/UI to perform the CRUD actions on the Isar db and update UI of the 'Shared tasks' page.

*/

import 'package:dart_either/dart_either.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/repository/shared_todo_domain_repository.dart';

class SharedTodoUsecases {
  final SharedTodoDomainRepository sharedTodoDomainRepository;

  SharedTodoUsecases({required this.sharedTodoDomainRepository});

  Future<Either<ToDoIsarFetchFailure, void>> fetchSharedTodosFromCloud() async {
    try {
      return await sharedTodoDomainRepository.fetchSharedTodosFromCloud();
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: '$e'));
    }
  }

  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>>
  fetchSharedTodo() async {
    try {
      return await sharedTodoDomainRepository.fetchSharedTodo();
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: '$e'));
    }
  }

  Future<Either<ToDoIsarUpdateFailure, void>> updateSharedTodo(
    int id,
    String content,
  ) async {
    try {
      return await sharedTodoDomainRepository.updateSharedTodo(id, content);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: '$e'));
    }
  }

  Future<Either<ToDoIsarUpdateFailure, void>> shareTodo(
    int id,
    String email,
  ) async {
    try {
      return await sharedTodoDomainRepository.shareTodo(id, email);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: '$e'));
    }
  }

  Future<Either<ToDoIsarUpdateFailure, void>> toggleSharedTodo(int id) async {
    try {
      return await sharedTodoDomainRepository.toggleSharedTodo(id);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: '$e'));
    }
  }
}

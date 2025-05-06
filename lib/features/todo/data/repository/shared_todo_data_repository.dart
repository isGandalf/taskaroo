/*

This class will define the contracts set in domain layer. In this case, actual operations needed
for the app to run its core logic is implemented. This class will primarily focus on 'Shared Tasks' page
where it will fetch data from cloud and local, push data to cloud and perform only update operations
(change completion status of the task and update the task content).

*/

// ignore: implementation_imports
import 'package:dart_either/src/dart_either.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/features/todo/data/source/isar_shared_todo.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/repository/shared_todo_domain_repository.dart';

class SharedTodoDataRepository implements SharedTodoDomainRepository {
  final IsarSharedTodo isarSharedTodo;

  SharedTodoDataRepository({required this.isarSharedTodo});

  @override
  Future<Either<ToDoIsarFetchFailure, void>>
  pushLocalSharedTodosToCloud() async {
    try {
      return await isarSharedTodo.pushLocalSharedTodosToCloud();
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: '$e'));
    }
  }

  @override
  Future<Either<ToDoIsarFetchFailure, void>> fetchSharedTodosFromCloud() async {
    try {
      return await isarSharedTodo.fetchSharedTodosFromCloud();
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: '$e'));
    }
  }

  @override
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>>
  fetchSharedTodo() async {
    try {
      return await isarSharedTodo.fetchSharedTodo();
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: '$e'));
    }
  }

  @override
  Future<Either<ToDoIsarUpdateFailure, void>> shareTodo(
    int id,
    String email,
  ) async {
    try {
      return await isarSharedTodo.shareTodo(id, email);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: '$e'));
    }
  }

  @override
  Future<Either<ToDoIsarUpdateFailure, void>> toggleSharedTodo(int id) async {
    try {
      return await isarSharedTodo.toggleSharedTodo(id);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: '$e'));
    }
  }

  @override
  Future<Either<ToDoIsarUpdateFailure, void>> updateSharedTodo(
    int id,
    String content,
  ) async {
    try {
      return await isarSharedTodo.updateSharedTodo(id, content);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: '$e'));
    }
  }
}

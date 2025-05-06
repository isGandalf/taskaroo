import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: implementation_imports
import 'package:dart_either/src/dart_either.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/features/todo/data/source/isar_local_source.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/repository/todo_domain_repository.dart';

class TodoDataRepository implements TodoDomainRepository {
  final IsarLocalSource isarLocalSource;

  TodoDataRepository({required this.isarLocalSource});

  // push local data to cloud
  @override
  Future<Either<TodoFirebaseSync, void>> pushLocalTodosToCloud() async {
    try {
      await isarLocalSource.pushLocalTodosToCloud();
      return Right(null);
    } catch (e) {
      return Left(TodoFirebaseSync(error: '$e'));
    }
  }

  // fetch cloud data to local
  @override
  Future<Either<TodoFirebaseSync, void>> fetchTodosFromCloud() async {
    try {
      final result = await isarLocalSource.fetchTodoFromCloud();

      return result.fold(
        ifLeft: (failure) => Left(TodoFirebaseSync(error: failure.error)),
        ifRight: (model) => Right(null),
      );
    } on FirebaseException catch (e) {
      return Left(
        TodoFirebaseSync(error: 'Unexpected error when syncing from cloud: $e'),
      );
    }
  }

  // fetch local data for UI
  @override
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>> fetchToDos() async {
    try {
      final todoFromIsar = await isarLocalSource.fetchTodo();
      return todoFromIsar.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (models) => Right(models),
      );
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: 'Unexpectd todo fetch failure'));
    }
  }

  // add new data
  @override
  Future<Either<ToDoIsarWriteFailure, void>> addToDo(ToDoEntity newTodo) async {
    try {
      final todoFromEntity = await isarLocalSource.addNewTodo(newTodo);
      return todoFromEntity.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (model) => Right(model),
      );
    } catch (e) {
      return Left(ToDoIsarWriteFailure(error: 'Unexpected todo add failure'));
    }
  }

  // delete existing data
  @override
  Future<Either<TodoIsarDeleteFailure, void>> deleteToDo(int id) async {
    try {
      final todoFromEntity = await isarLocalSource.deleteTodo(id);
      return todoFromEntity.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (model) => Right(model),
      );
    } catch (e) {
      return Left(TodoIsarDeleteFailure(error: 'Unexpeceted delete failure'));
    }
  }

  // update existing data
  @override
  Future<Either<ToDoIsarUpdateFailure, void>> updateToDo(
    int id,
    String content,
  ) async {
    try {
      final todoFromEntity = await isarLocalSource.updateTodo(id, content);
      return todoFromEntity.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (model) => Right(model),
      );
    } catch (e) {
      return Left(
        ToDoIsarUpdateFailure(error: 'Unexpected todo update failure'),
      );
    }
  }

  // update todo status
  @override
  Future<Either<ToDoIsarUpdateFailure, void>> toggleCompletionStatus(
    int id,
  ) async {
    try {
      final updatedTodo = await isarLocalSource.updateCompletedStatus(id);
      return updatedTodo.fold(
        ifLeft: (failure) => Left(ToDoIsarUpdateFailure(error: failure.error)),
        ifRight: (todo) => Right(todo),
      );
    } catch (e) {
      return Left(
        ToDoIsarUpdateFailure(error: 'Unexprected todo status update failure'),
      );
    }
  }
}

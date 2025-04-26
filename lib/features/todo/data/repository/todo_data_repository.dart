import 'package:dart_either/src/dart_either.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/features/todo/data/source/isar_local_source.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';
import 'package:taskaroo/features/todo/domain/repository/todo_domain_repository.dart';

class TodoDataRepository implements TodoDomainRepository {
  final IsarLocalSource isarLocalSource;

  TodoDataRepository({required this.isarLocalSource});

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

  @override
  Future<Either<TodoIsarDeleteFailure, void>> deleteToDo(
    ToDoEntity todo,
  ) async {
    try {
      final todoFromEntity = await isarLocalSource.deleteTodo(todo);
      return todoFromEntity.fold(
        ifLeft: (failure) => Left(failure),
        ifRight: (model) => Right(model),
      );
    } catch (e) {
      return Left(TodoIsarDeleteFailure(error: 'Unexpeceted delete failure'));
    }
  }

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

  @override
  Future<Either<ToDoIsarUpdateFailure, void>> updateToDo(
    ToDoEntity todo,
  ) async {
    try {
      final todoFromEntity = await isarLocalSource.updateTodo(todo);
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

  @override
  Future<Either<ToDoIsarUpdateFailure, void>> toggleCompletionStatus(
    ToDoEntity todo,
  ) async {
    try {
      final updatedTodo = await isarLocalSource.updateCompletedStatus(todo);
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

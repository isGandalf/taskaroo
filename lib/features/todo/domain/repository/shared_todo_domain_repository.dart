import 'package:dart_either/dart_either.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';

abstract interface class SharedTodoDomainRepository {
  Future<Either<ToDoIsarFetchFailure, void>> fetchSharedTodosFromCloud();
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>> fetchSharedTodo();
  Future<Either<ToDoIsarFetchFailure, void>> pushLocalSharedTodosToCloud();
  Future<Either<ToDoIsarUpdateFailure, void>> updateSharedTodo(
    int id,
    String content,
  );
  Future<Either<ToDoIsarUpdateFailure, void>> toggleSharedTodo(int id);
  Future<Either<ToDoIsarUpdateFailure, void>> shareTodo(int id, String email);
}

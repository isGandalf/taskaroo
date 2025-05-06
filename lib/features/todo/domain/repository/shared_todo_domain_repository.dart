/*

This repository will act as a contract to ensure implementation of the functions. The actual implementation will
be handled by data layer. Below are main functions to be implemented

1. Fetch shared todos from local
2. update todos
3. toggle completion status of the todo
4. push local shared todos to cloud
5. fetch todos from cloud and save to local.
6. shared a todo with someone.

This will control all the todos in 'Shared tasks' page.

*/

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

/*

This repository will act as a contract to ensure implementation of the functions. The actual implementation will
be handled by data layer. Below are main functions to be implemented

1. Fetch todos
2. add todos
3. update todos
4. delete todos

*/

import 'package:dart_either/dart_either.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';

abstract interface class TodoDomainRepository {
  // push local todos to cloud
  Future<Either<TodoFirebaseSync, void>> pushLocalTodosToCloud();

  // fetch todos from cloud
  Future<Either<TodoFirebaseSync, void>> fetchTodosFromCloud();

  // Fetch
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>> fetchToDos();

  // add / write
  Future<Either<ToDoIsarWriteFailure, void>> addToDo(ToDoEntity newTodo);

  // read / update
  Future<Either<ToDoIsarUpdateFailure, void>> updateToDo(ToDoEntity todo);

  // delete
  Future<Either<TodoIsarDeleteFailure, void>> deleteToDo(ToDoEntity todo);

  // update completion status
  Future<Either<ToDoIsarUpdateFailure, void>> toggleCompletionStatus(
    ToDoEntity todo,
  );

  // cloud sync
  // Future<Either<TodoFirebaseSync, void>> cloudUpdate(ToDoEntity todo);
}

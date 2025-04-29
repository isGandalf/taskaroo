/*

This class will interact with ISAR db and perform 4 operations
1. Fetch todos
2. add todo
3. update todo
4. delete todo

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/todo/data/models/todo_model.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';

class IsarLocalSource {
  final Isar db;
  final FirebaseFirestore firebaseFirestore;
  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  IsarLocalSource({required this.db, required this.firebaseFirestore});

  // F E T C H
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>> fetchTodo() async {
    try {
      final userId = currentUser!.uid;

      // fetch all documents from isar collection
      final todoFromIsar =
          await db.toDoModels.filter().userIdEqualTo(userId).findAll();

      // return the result to entity
      return Right(
        todoFromIsar.map((e) {
          //logger.d(' in locale ${todoFromIsar.length}');
          return e.toEntity();
        }).toList(),
      );
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: 'Unable to fetch'));
    }
  }

  // A D D
  Future<Either<ToDoIsarWriteFailure, void>> addNewTodo(
    ToDoEntity newTodo,
  ) async {
    try {
      final userId = currentUser!.uid;
      // convert dart object to isar object
      final todoFromEntity = ToDoModel.fromModelToIsar(newTodo);
      todoFromEntity.userId = userId;
      todoFromEntity.createdAt = DateTime.now();

      // add the todo to isar
      await db.writeTxn(() => db.toDoModels.put(todoFromEntity));

      return Right(null);
    } catch (e) {
      return Left(ToDoIsarWriteFailure(error: 'Unable to add new todo'));
    }
  }

  // U P D A T E
  Future<Either<ToDoIsarUpdateFailure, void>> updateTodo(
    ToDoEntity todo,
  ) async {
    try {
      final userId = currentUser!.uid;
      // same as add new todo
      final todoFromEntity = ToDoModel.fromModelToIsar(todo);
      todoFromEntity.userId = userId;

      todoFromEntity.updatedAt = DateTime.now();

      await db.writeTxn(() => db.toDoModels.put(todoFromEntity));
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Update failed'));
    }
  }

  // D E L E T E
  Future<Either<TodoIsarDeleteFailure, void>> deleteTodo(
    ToDoEntity todo,
  ) async {
    try {
      final userId = currentUser!.uid;
      final existingTodo = await db.toDoModels.get(todo.id);
      if (existingTodo?.userId != userId) {
        return Left(
          TodoIsarDeleteFailure(
            error:
                'Todo does not belong to user :: UserId - $userId and todo id - ${existingTodo?.id} ',
          ),
        );
      }
      await db.writeTxn(() => db.toDoModels.delete(todo.id));
      return Right(null);
    } catch (e) {
      return Left(TodoIsarDeleteFailure(error: 'Unable to delete todo'));
    }
  }

  // T O G G L E
  Future<Either<ToDoIsarUpdateFailure, void>> updateCompletedStatus(
    ToDoEntity todo,
  ) async {
    try {
      final userId = currentUser!.uid;

      final updatedTodo = todo.toggleStatus();

      final todoForIsar = ToDoModel.fromModelToIsar(updatedTodo);

      todoForIsar.userId = userId;
      await db.writeTxn(() => db.toDoModels.put(todoForIsar));
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Todo status update failed'));
    }
  }

  // F I R E S T O R E
  Future<Either<TodoFirebaseSync, void>> cloudSync(ToDoEntity todo) async {
    try {
      final userId = currentUser!.uid;

      if (currentUser != null) {
        await firebaseFirestore
            .collection('todos')
            .doc(todo.id.toString())
            .set({
              'id': todo.id,
              'content': todo.content,
              'createdAt': todo.createdAt,
              'updatedAt': todo.updatedAt,
              'ownerId': userId,
              'isCompleted': todo.isCompleted,
              'sharedWith': [],
            });
      }

      logger.d('Firestore saving successful');
      return Right(null);
    } on FirebaseException catch (e) {
      logger.e('Firestore exception $e');
      return Left(TodoFirebaseSync(error: 'Failed to save in firestore: $e'));
    }
  }
}

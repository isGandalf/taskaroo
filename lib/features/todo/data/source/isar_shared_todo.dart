/*

This class will interact with ISAR db and perform CRUD operations. Along with that, push local data to cloud
and fetch updated data and save to local. The application's business logic will primarily work with local 
data. This class with manage the 'Shared tasks' page.


*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isar/isar.dart';
import 'package:taskaroo/core/errors/todo_errors.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/features/todo/data/models/todo_model.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';

class IsarSharedTodo {
  final FirebaseFirestore firebaseFirestore;
  final Isar db;

  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  IsarSharedTodo({required this.db, required this.firebaseFirestore});

  // Put local todos to cloud
  Future<Either<ToDoIsarFetchFailure, void>>
  pushLocalSharedTodosToCloud() async {
    try {
      if (currentUser != null) {
        final email = currentUser?.email;

        if (email != null) {
          // gather unsynced todos
          final unSynchedSharedTodosFromLocal =
              await db.toDoModels
                  .filter()
                  .sharedWithContains(email)
                  .isSyncedEqualTo(false)
                  .findAll();

          if (unSynchedSharedTodosFromLocal.isEmpty) return Right(null);

          // covert to entity obj
          final unSyncedListEntity =
              unSynchedSharedTodosFromLocal.map((e) => e.toEntity()).toList();

          // perform batch operation
          final batch = firebaseFirestore.batch();
          for (final sharedTodoItem in unSyncedListEntity) {
            final docRef = firebaseFirestore
                .collection('todos')
                .doc(sharedTodoItem.id.toString());

            batch.update(docRef, {
              'isCompleted': sharedTodoItem.isCompleted,
              'isSynced': true,
              'updatedAt': sharedTodoItem.updatedAt,
              'content': sharedTodoItem.content,
              'isShared': true,
            });
          }
          await batch.commit();
          await updateLocalDbWithCloudData(unSyncedListEntity);
        } else {
          return Left(ToDoIsarFetchFailure(error: 'Email is null'));
        }
      }
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: '$e'));
    }
  }

  // Fetch shared todo from cloud and save in local db
  Future<Either<ToDoIsarFetchFailure, void>> fetchSharedTodosFromCloud() async {
    try {
      // execute when user exist
      if (currentUser != null) {
        final email = currentUser?.email;
        // when email is not null, because we are fetching all todos when sharedWith
        // contains the current user email
        if (email != null) {
          final sharedTodoSnapshot =
              await firebaseFirestore
                  .collection('todos')
                  .where('sharedWith', isEqualTo: email)
                  .get();

          // extract snapshot data to list and map to entity
          final sharedTodoList =
              sharedTodoSnapshot.docs.map((todoList) {
                final todo = todoList.data();
                return ToDoEntity(
                  id: todo['id'],
                  content: todo['content'],
                  userId: todo['userId'],
                  createdAt: (todo['createdAt'] as Timestamp).toDate(),
                  updatedAt:
                      todo['updatedAt'] != null
                          ? (todo['updatedAt'] as Timestamp).toDate()
                          : null,
                  isCompleted: todo['isCompleted'],
                  isSynced: todo['isSynced'],
                  isShared: todo['isShared'],
                  sharedWith: todo['sharedWith'],
                );
              }).toList();

          //logger.d('SharedTodoList received from cloud is - $sharedTodoList');

          // save to local db
          final savedList = await updateLocalDbWithCloudData(sharedTodoList);
          return savedList.fold(
            ifLeft:
                (failure) => Left(ToDoIsarFetchFailure(error: failure.error)),
            ifRight: (_) => Right(null),
          );
        } else {
          return Left(ToDoIsarFetchFailure(error: 'Email does not exist'));
        }
      } else {
        return Left(ToDoIsarFetchFailure(error: 'Current user is null'));
      }
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: 'Exception: $e'));
    }
  }

  // helper function to save the fetched cloud data to local db
  Future<Either<ToDoIsarWriteFailure, void>> updateLocalDbWithCloudData(
    List<ToDoEntity> todoList,
  ) async {
    try {
      await db.writeTxn(() async {
        final todoForIsar =
            todoList.map((todoModel) {
              return ToDoModel.fromModelToIsar(todoModel);
            }).toList();

        await db.toDoModels.putAll(todoForIsar);
      });

      return Right(null);
    } on Exception catch (e) {
      return Left(
        ToDoIsarWriteFailure(error: 'Failed to load data from cloud: $e'),
      );
    }
  }

  /*   C R U D    */
  // F E T C H    F R O M    I S A R (used in UI)
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>>
  fetchSharedTodo() async {
    try {
      final email = currentUser?.email;

      if (email != null) {
        final sharedListFromIsar =
            await db.toDoModels.filter().sharedWithContains(email).findAll();

        if (sharedListFromIsar.isEmpty) {
          return Right([]);
        }

        return Right(sharedListFromIsar.map((e) => e.toEntity()).toList());
      } else {
        return Left(ToDoIsarFetchFailure(error: 'No email found -- $email'));
      }
    } catch (e) {
      return Left(
        ToDoIsarFetchFailure(error: 'Unable to fetch shared list ---  $e'),
      );
    }
  }

  Future<Either<ToDoIsarUpdateFailure, void>> updateSharedTodo(
    int id,
    String content,
  ) async {
    try {
      final todoFromIsar = await db.toDoModels.get(id);
      logger.d(content);
      if (todoFromIsar == null) {
        return Left(ToDoIsarUpdateFailure(error: 'No todo found'));
      }

      final todo = todoFromIsar.toEntity();
      final updated = todo.copyWith(
        content: content,
        isSynced: false,
        updatedAt: DateTime.now(),
        isCompleted: false,
      );
      final todoForIsar = ToDoModel.fromModelToIsar(updated);
      await db.writeTxn(() => db.toDoModels.put(todoForIsar));
      pushLocalSharedTodosToCloud();
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'unable to update todo -- $e'));
    }
  }

  // share Todo
  Future<Either<ToDoIsarUpdateFailure, void>> shareTodo(
    int id,
    String email,
  ) async {
    try {
      final todoFromIsar = await db.toDoModels.get(id);

      if (todoFromIsar == null) {
        return Left(ToDoIsarUpdateFailure(error: 'no todo found'));
      }

      final todo = todoFromIsar.toEntity();
      final updated = todo.copyWith(
        sharedWith: email,
        isShared: true,
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      final todoForIsar = ToDoModel.fromModelToIsar(updated);
      await db.writeTxn(() => db.toDoModels.put(todoForIsar));
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Unable to share todo --- $e'));
    }
  }

  // update completion status of the shared Todo
  Future<Either<ToDoIsarUpdateFailure, void>> toggleSharedTodo(int id) async {
    try {
      final todoFromIsar = await db.toDoModels.get(id);
      if (todoFromIsar == null) {
        return Left(ToDoIsarUpdateFailure(error: 'No todo found'));
      }
      final todo = todoFromIsar.toEntity();
      final status = todo.isCompleted == false ? true : false;
      final updated = todo.copyWith(
        isCompleted: status,
        isSynced: false,
        updatedAt: DateTime.now(),
      );
      final todoForIsar = ToDoModel.fromModelToIsar(updated);
      await db.writeTxn(() => db.toDoModels.put(todoForIsar));
      pushLocalSharedTodosToCloud();
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Unable to toggle todo --- $e'));
    }
  }
}

/*

This class will interact with ISAR db and perform 4 operations
1. Fetch todos
  a) Here, upon user login and app start, cloud fetch will trigger for once and save the data in
     local db.
2. add todo
  a) Once added, it will save the data in local db as well as cloud. But cloud fetch will not 
     trigger since data in cloud, as well as local are identical.
3. update todo
  a) Similar to add todo.
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

  /*
  Flow of execution:
  1. Fetch the data from cloud filterd by userId
  2. Save the data in local db
  3. Fetch the data from local db and feed to UI
  4. CRUD functions:
    a) Create - add new todo in local db and update to cloud
    b) Read - fetch data from local db (recurring)
    c) Update - update (including toggle function) an existing todo to local db and cloud
    d) Delete - delete an existing todo from local and cloud
  */

  // P U S H     L O C A L     D A T A     T O     C L O U D (where isSynced are false)
  Future<Either<ToDoIsarFetchFailure, void>> pushLocalTodosToCloud() async {
    try {
      // start this operation when user is not null
      if (currentUser != null) {
        // initialize userId
        final userId = currentUser!.uid;

        // fetch data from cloud
        // final cloudData = await fetchTodoFromCloud();

        // fetch the todos where isSynced = false and userId = currentUser
        final unSyncedList =
            await db.toDoModels
                .filter()
                .isSyncedEqualTo(false)
                .userIdContains(userId)
                .findAll();

        if (unSyncedList.isEmpty) {
          logger.d('Empty list. Nothing to sync to cloud');
          return Right(null);
        }

        final unSyncedListEntity =
            unSyncedList.map((eachTodoModel) {
              return eachTodoModel.toEntity();
            }).toList();

        // perform batch operation to cloud
        final batch = firebaseFirestore.batch();
        for (final todoItem in unSyncedListEntity) {
          final docRef = firebaseFirestore
              .collection('todos')
              .doc(todoItem.id.toString());

          batch.set(docRef, {
            'content': todoItem.content,
            'isCompleted': todoItem.isCompleted,
            'updatedAt': todoItem.updatedAt,
            'isSynced': true,
            'userId': userId,
            'id': todoItem.id,
            'createdAt': todoItem.createdAt,
          });
        }
        // push to cloud
        await batch.commit();
        logger.d('Sync to cloud successful');
      }
      return Right(null);
    } on FirebaseException catch (e) {
      logger.e('Log -- $e');
      return Left(ToDoIsarFetchFailure(error: 'Sync to cloud failed.'));
    }
  }

  // F E T C H     F R O M     C L O U D (save in local for UI consumption)
  Future<Either<TodoFirebaseSync, void>> fetchTodoFromCloud() async {
    try {
      //get snapshot
      final userId = currentUser!.uid;
      logger.d(
        'Fetching data of $userId from cloud and will be saving to local.',
      );
      final todosFromFirestore =
          await firebaseFirestore
              .collection('todos')
              .where('userId', isEqualTo: userId)
              .get();

      if (todosFromFirestore.docs.isNotEmpty) {
        logger.d('Data received --- ${todosFromFirestore.docs.length}');
      }

      //get list of todos from snapshot
      final result =
          todosFromFirestore.docs.map((todoList) {
            try {
              final todoItem = todoList.data();

              logger.d('Getting results -- $todoItem');
              return ToDoEntity(
                id: todoItem['id'],
                content: todoItem['content'],
                userId: todoItem['userId'],
                createdAt: (todoItem['createdAt'] as Timestamp).toDate(),
                updatedAt:
                    todoItem['updatedAt'] != null
                        ? (todoItem['updatedAt'] as Timestamp).toDate()
                        : null,
                isCompleted: todoItem['isCompleted'],
                isSynced: todoItem['isSynced'],
              );
            } catch (e) {
              logger.e('Error parsing todoList: ${todoList.data()}, error: $e');
              rethrow;
            }
          }).toList();

      logger.d('Result - $result');

      if (result.isNotEmpty) {
        logger.d('Result is not empty - $result');
      }

      final todoList = await updateLocalDbWithCloudData(result);
      return todoList.fold(
        ifLeft: (failure) {
          logger.e('From firebase: $failure');
          return Left(TodoFirebaseSync(error: failure.error));
        },
        ifRight: (_) => Right(null),
      );
    } on FirebaseException catch (e) {
      return Left(TodoFirebaseSync(error: 'Firebase sync error: $e'));
    }
  }

  // helper function to save the fetched cloud data to local db
  Future<Either<ToDoIsarWriteFailure, void>> updateLocalDbWithCloudData(
    List<ToDoEntity> todoList,
  ) async {
    logger.d('Cloud todo list length: ${todoList.length}');

    try {
      await db.writeTxn(() async {
        final todoForIsar =
            todoList.map((todoModel) {
              return ToDoModel.fromModelToIsar(todoModel);
            }).toList();

        await db.toDoModels.putAll(todoForIsar);
      });

      final allTodos = await db.toDoModels.where().findAll();
      logger.d('Todos in local DB after update: $allTodos');

      return Right(null);
    } on Exception catch (e) {
      return Left(
        ToDoIsarWriteFailure(error: 'Failed to load data from cloud: $e'),
      );
    }
  }

  // helper function to save the todo to cloud
  // Future<Either<TodoFirebaseSync, void>> cloudUpdate(ToDoEntity todo) async {
  //   try {
  //     if (currentUser != null) {
  //       final userId = currentUser!.uid;
  //       await firebaseFirestore
  //           .collection('todos')
  //           .doc(todo.id.toString())
  //           .set({
  //             'id': todo.id,
  //             'content': todo.content,
  //             'createdAt': todo.createdAt,
  //             'updatedAt': todo.updatedAt,
  //             'ownerId': userId,
  //             'isCompleted': todo.isCompleted,
  //             'sharedWith': [],
  //           });
  //     }
  //     logger.d('Firestore saving successful');
  //     return Right(null);
  //   } on FirebaseException catch (e) {
  //     logger.e('Firestore exception $e');
  //     return Left(TodoFirebaseSync(error: 'Failed to save in firestore: $e'));
  //   }
  // }

  /*     CRUD OPERATIONS     */

  // F E T C H    F R O M    I S A R (used in UI)
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>> fetchTodo() async {
    try {
      final userId = currentUser!.uid;

      // fetch all documents from isar collection
      final todoFromIsar =
          await db.toDoModels.filter().userIdEqualTo(userId).findAll();

      if (todoFromIsar.isEmpty) {
        logger.d('Fetch todo - local list empty');
        return Right([]);
      }

      // return the result to entity
      return Right(
        todoFromIsar.map((e) {
          //logger.d(' in locale ${todoFromIsar.length}');
          return e.toEntity();
        }).toList(),
      );
    } catch (e) {
      return Left(ToDoIsarFetchFailure(error: 'Unable to fetch ---  $e'));
    }
  }

  // A D D (used in UI)
  Future<Either<ToDoIsarWriteFailure, void>> addNewTodo(
    ToDoEntity newTodo,
  ) async {
    try {
      if (currentUser != null) {
        // convert dart object to isar object
        final todoFromEntity = ToDoModel.fromModelToIsar(newTodo);

        // add the todo to isar
        await db.writeTxn(() => db.toDoModels.put(todoFromEntity));
      }
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarWriteFailure(error: 'Unable to add new todo --- $e'));
    }
  }

  // U P D A T E (used in UI)
  Future<Either<ToDoIsarUpdateFailure, void>> updateTodo(
    ToDoEntity todo,
  ) async {
    try {
      if (currentUser != null) {
        final now = DateTime.now();
        // same as add new todo
        final todoForIsar = ToDoModel.fromModelToIsar(todo);
        todoForIsar.updatedAt = now;

        // set the value to false so that it can be synced to cloud.
        todoForIsar.isSynced = false;

        // update to isar
        await db.writeTxn(() => db.toDoModels.put(todoForIsar));
      }

      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Update failed --- $e'));
    }
  }

  // D E L E T E  (used in UI)
  Future<Either<TodoIsarDeleteFailure, void>> deleteTodo(
    ToDoEntity todo,
  ) async {
    try {
      if (currentUser != null) {
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

        // delete from cloud
        firebaseFirestore
            .collection('todos')
            .doc(todo.id.toString())
            .delete()
            .catchError((e) {
              logger.e('Unable to delete --- $e');
            });
      }

      return Right(null);
    } catch (e) {
      return Left(TodoIsarDeleteFailure(error: 'Unable to delete todo -- $e'));
    }
  }

  // T O G G L E  (used in UI)
  Future<Either<ToDoIsarUpdateFailure, void>> updateCompletedStatus(
    ToDoEntity todo,
  ) async {
    try {
      if (currentUser != null) {
        final now = DateTime.now();
        final status = todo.isCompleted ? false : true;

        final updatedTodo = todo.copyWith(isCompleted: status, updatedAt: now);

        final todoForIsar = ToDoModel.fromModelToIsar(updatedTodo);

        // set the value to false so that it can be synced to cloud
        todoForIsar.isSynced = false;

        await db.writeTxn(() => db.toDoModels.put(todoForIsar));
      }

      return Right(null);
    } catch (e) {
      return Left(
        ToDoIsarUpdateFailure(error: 'Todo status update failed --- $e'),
      );
    }
  }
}

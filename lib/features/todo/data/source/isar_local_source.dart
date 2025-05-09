/*

This class will interact with ISAR db and perform CRUD operations. Along with that, push local data to cloud
and fetch updated data and save to local. The application's business logic will primarily work with local 
data. This class with manage the 'My tasks' page.


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
  5. Push the local data to cloud
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
          //logger.d('Empty list. Nothing to sync to cloud');
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
            'isShared': todoItem.isShared,
            'sharedWith': todoItem.sharedWith,
          });
        }
        // push to cloud
        await batch.commit();
        //logger.d('Sync to cloud successful');
      }
      return Right(null);
    } on FirebaseException {
      //logger.e('Log -- $e');
      return Left(ToDoIsarFetchFailure(error: 'Sync to cloud failed.'));
    }
  }

  // F E T C H     F R O M     C L O U D (save in local for UI consumption)
  Future<Either<TodoFirebaseSync, void>> fetchTodoFromCloud() async {
    try {
      //get snapshot
      final userId = currentUser!.uid;
      final todosFromFirestore =
          await firebaseFirestore
              .collection('todos')
              .where('userId', isEqualTo: userId)
              .get();

      //get list of todos from snapshot
      final result =
          todosFromFirestore.docs.map((todoList) {
            try {
              final todoItem = todoList.data();
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
                sharedWith: todoItem['sharedWith'],
                isShared: todoList['isShared'],
              );
            } catch (e) {
              logger.e('Error parsing todoList: ${todoList.data()}, error: $e');
              rethrow;
            }
          }).toList();

      final todoList = await updateLocalDbWithCloudData(result);
      return todoList.fold(
        ifLeft: (failure) {
          //logger.e('From firebase: $failure');
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

  /*     CRUD OPERATIONS     */

  // F E T C H    F R O M    I S A R (used in UI)
  Future<Either<ToDoIsarFetchFailure, List<ToDoEntity>>> fetchTodo() async {
    try {
      final userId = currentUser!.uid;

      // fetch all documents from isar collection
      final todoFromIsar =
          await db.toDoModels.filter().userIdEqualTo(userId).findAll();

      if (todoFromIsar.isEmpty) {
        //logger.d('Fetch todo - local list empty');
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
    int id,
    String content,
  ) async {
    try {
      final todoFromIsar = await db.toDoModels.get(id);

      if (todoFromIsar == null) {
        return Left(ToDoIsarUpdateFailure(error: 'Todo not found'));
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

      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Failed to update todo: $e'));
    }
  }

  // D E L E T E  (used in UI)
  Future<Either<TodoIsarDeleteFailure, void>> deleteTodo(int id) async {
    try {
      final todoFromIsar = await db.toDoModels.get(id);
      if (todoFromIsar == null) {
        return Left(TodoIsarDeleteFailure(error: 'No todo found'));
      }
      await db.writeTxn(() => db.toDoModels.delete(id));
      await firebaseFirestore
          .collection('todos')
          .doc(id.toString())
          .delete()
          .catchError((e) => logger.e('No todo in database -- $e'));

      return Right(null);
    } catch (e) {
      return Left(TodoIsarDeleteFailure(error: 'Unable to delete todo -- $e'));
    }
  }

  // T O G G L E  (used in UI)
  Future<Either<ToDoIsarUpdateFailure, void>> updateCompletedStatus(
    int id,
  ) async {
    try {
      final todoFromIsar = await db.toDoModels.get(id);

      if (todoFromIsar == null) {
        return Left(ToDoIsarUpdateFailure(error: 'Todo not found'));
      }

      final status = todoFromIsar.isCompleted == true ? false : true;

      final todo = todoFromIsar.toEntity();
      final updated = todo.copyWith(
        isCompleted: status,
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      final todoForIsar = ToDoModel.fromModelToIsar(updated);

      await db.writeTxn(() => db.toDoModels.put(todoForIsar));
      return Right(null);
    } catch (e) {
      return Left(ToDoIsarUpdateFailure(error: 'Toggle failed: $e'));
    }
  }
}

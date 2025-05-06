/*

* This class will handle all Todo local Isar db errors mainly:
* 1. write - when local db is corrupt or app crashed while writing
* 2. read - db read failures like reading a null result or no db
* 3. model errors - if isar model isn't correctly defined like field type mismatch
* 4. delete failures - when deleting non existed item from db

*/

abstract interface class TodoFailures {
  String get message;
}

final class ToDoIsarWriteFailure extends TodoFailures {
  final String error;
  ToDoIsarWriteFailure({required this.error});

  @override
  String get message => 'Write failure: $error';
}

final class ToDoIsarFetchFailure extends TodoFailures {
  final String error;

  ToDoIsarFetchFailure({required this.error});

  @override
  String get message => 'Fetch failure: $error';
}

final class ToDoIsarUpdateFailure extends TodoFailures {
  final String error;

  ToDoIsarUpdateFailure({required this.error});

  @override
  String get message => 'Update failure: $error';
}

final class TodoIsarDeleteFailure extends TodoFailures {
  final String error;

  TodoIsarDeleteFailure({required this.error});

  @override
  String get message => 'Query failure: $error';
}

final class TodoFirebaseSync extends TodoFailures {
  final String error;

  TodoFirebaseSync({required this.error});

  @override
  String get message => 'Firebase Update failed $error';
}

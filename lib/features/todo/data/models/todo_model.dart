/*

This class with be responsible for handling data from and to ISAR local db. This model will be
similar to ToDoEntity of domain layer.

Apart from same data variables, it will convert 'fromISAR' to dart object and dart object to 'ISARreadable' format.

Note - Here we will use Isar datatype to create id and assign late to the custom variables.

*/

import 'package:isar/isar.dart';
import 'package:taskaroo/features/todo/domain/entity/todo_entity.dart';

// to generate isar_model todo object using build runner.
// run command : dart run build_runner build
part 'todo_model.g.dart';

@Collection()
class ToDoModel {
  Id id = Isar.autoIncrement;
  late String content;
  late String userId;
  late bool isCompleted;

  // dart object to Isar object (from domain). This is need when we add and update. User sends ToDo entity to isar source.
  static ToDoModel fromModelToIsar(ToDoEntity todo) {
    var model = ToDoModel();
    model.id = todo.id;
    model.content = todo.content;
    model.userId = todo.userId;
    model.isCompleted = todo.isCompleted;
    return model;
  }

  // covert Isar to dart object (to domain)
  ToDoEntity toEntity() {
    return ToDoEntity(
      id: id,
      content: content,
      isCompleted: isCompleted,
      userId: userId,
    );
  }
}

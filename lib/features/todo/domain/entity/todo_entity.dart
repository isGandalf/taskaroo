/*

This is the main business requirement for the app. This will have 9 properties to maintain
the business data (application data).

1. id - an unique identification of each todo created. The id is set by Isar using millisecondssinceEpoch.
2. content - actual content or the todo created by user.
3. userId - todo owner identification. This is created by firebase.
4. createdAt - to track the original todo created date-time.
5. updatedAt - to track the updated date-time of the todo. This will be nullable when instantiated.
6. isCompleted - to track the current todo completion status.
7. isSynced - to track the todo is ready to sync to cloud
8. isShared - to track if the todo is shared with anyone.
9. sharedWith - to track with whom the todo is shared so that we can query it on 'shared tasks' page.

In addition to above, this class will also have a 'copyWith' function which will manage only the data that can
change during any application use cases like update content, updated at, is synced etc. Only id, userId and createdAt
will not be changed since it is crucial data for identification.

*/

class ToDoEntity {
  final int id;
  final String content;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isCompleted;
  final bool isSynced;
  final bool isShared;
  final String? sharedWith;

  ToDoEntity({
    required this.id,
    required this.content,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
    this.isSynced = false,
    this.isShared = false,
    this.sharedWith,
  });

  ToDoEntity copyWith({
    String? content,
    DateTime? updatedAt,
    bool? isCompleted,
    bool? isSynced,
    String? sharedWith,
    bool? isShared,
  }) {
    return ToDoEntity(
      id: id,
      content: content ?? this.content,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      isSynced: isSynced ?? this.isSynced,
      isShared: isShared ?? this.isShared,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }
}

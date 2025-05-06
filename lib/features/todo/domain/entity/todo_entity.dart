/*

This is the main business requirement for the app. It will have three properties 
related to todo feature.

1. todo id
2. todo content
3. todo status
4. user id

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

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
  final bool isCompleted;

  ToDoEntity({
    required this.id,
    required this.content,
    required this.userId,
    this.isCompleted = false,
  });

  ToDoEntity toggleStatus() {
    return ToDoEntity(
      id: id,
      content: content,
      isCompleted: !isCompleted,
      userId: userId,
    );
  }
}

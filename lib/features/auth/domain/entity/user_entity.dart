/*

This class defines essential business properties which represents the core user model required
for the application logic to perform. This is independent of data sources or frameworks.

The user model will hold
1. user first name
2. user last name
3. email
4. user id

*/

class UserEntity {
  final String firstName;
  final String lastName;
  final String email;
  final String uid;

  UserEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uid,
  });
}

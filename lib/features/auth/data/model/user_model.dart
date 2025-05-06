/*

* For maintaining separation of concern between data layer and domain layer, this class will replicate
* entity class from domain layer. This class will interact with cloud and manage the data. 

*/

import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String uid;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uid,
  });

  UserEntity toEntity() {
    return UserEntity(
      firstName: firstName,
      lastName: lastName,
      email: email,
      uid: uid,
    );
  }

  factory UserModel.fromFirestoreMap(
    String firstName,
    String lastName,
    String email,
    String uid,
  ) {
    return UserModel(
      firstName: firstName,
      lastName: lastName,
      email: email,
      uid: uid,
    );
  }
}

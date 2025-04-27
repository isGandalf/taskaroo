/*

This is a repository interface that defines the contracts required by the app.
The actual implementations will reside in the data layer. Contracts for the auth
feature include:

1. User sign-up
2. User login

*/

import 'package:dart_either/dart_either.dart';
import 'package:taskaroo/core/errors/firebase_errors.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';

abstract interface class UserDomainRepository {
  Future<Either<UserModelError, UserEntity>> userSignUp(
    String firstName,
    String lastName,
    String email,
    String password,
  );
  Future<Either<UserModelError, UserEntity>> userLogin(
    String email,
    String password,
  );
  Future<void> signOut();
  Future<Either<ResetPasswordError, void>> resetPassword(String email);
}

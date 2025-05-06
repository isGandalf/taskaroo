/*

This class defines application's operations. Each use case represent specific action or
feature related tasks. In this case, this will handle user authentication use cases such as
create new user, user login, signout and reset password.

*/

import 'package:dart_either/dart_either.dart';
import 'package:taskaroo/core/errors/firebase_errors.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';
import 'package:taskaroo/features/auth/domain/repository/user_domain_repository.dart';

class AuthUsecase {
  final UserDomainRepository userDomainRepository;

  AuthUsecase({required this.userDomainRepository});

  Future<Either<UserModelError, UserEntity>> userSignUp(
    String firstName,
    String lastName,
    String email,
    String password,
  ) {
    return userDomainRepository.userSignUp(
      firstName,
      lastName,
      email,
      password,
    );
  }

  Future<Either<UserModelError, UserEntity>> userLogin(
    String email,
    String password,
  ) {
    return userDomainRepository.userLogin(email, password);
  }

  Future<void> signOut() {
    return userDomainRepository.signOut();
  }

  Future<Either<ResetPasswordError, void>> resetPassword(String email) {
    return userDomainRepository.resetPassword(email);
  }
}

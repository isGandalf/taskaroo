import 'package:dart_either/dart_either.dart';
import 'package:taskaroo/core/errors/errors.dart';
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
}

// ignore: implementation_imports
import 'package:dart_either/src/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskaroo/core/errors/firebase_errors.dart';
import 'package:taskaroo/features/auth/data/model/user_model.dart';
import 'package:taskaroo/features/auth/data/sources/user_auth.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';
import 'package:taskaroo/features/auth/domain/repository/user_domain_repository.dart';

class UserDataRepository implements UserDomainRepository {
  final UserAuth userAuth;

  UserDataRepository({required this.userAuth});

  @override
  Future<void> signOut() {
    return userAuth.signOut();
  }

  @override
  Future<Either<UserModelError, UserEntity>> userLogin(
    String email,
    String password,
  ) async {
    final Either<FirebaseAuthError, UserModel> model = await userAuth.userLogin(
      email,
      password,
    );

    return model.fold(
      ifLeft: (failure) {
        return Left(
          UserModelError(
            getErrorMessage: failure.firebaseAuthException.message.toString(),
          ),
        );
      },
      ifRight: (userModel) {
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<UserModelError, UserEntity>> userSignUp(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final Either<FirebaseAuthError, UserModel> model = await userAuth
        .userSignUp(firstName, lastName, email, password);

    return model.fold(
      ifLeft: (failure) {
        return Left(
          UserModelError(
            getErrorMessage: failure.firebaseAuthException.message.toString(),
          ),
        );
      },
      ifRight: (userModel) {
        return Right(userModel.toEntity());
      },
    );
  }

  @override
  Future<Either<ResetPasswordError, void>> resetPassword(String email) async {
    try {
      await userAuth.resetPassword(email);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(ResetPasswordError(message: e.message.toString()));
    }
  }
}

import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskaroo/core/errors/errors.dart';
import 'package:taskaroo/features/auth/data/model/user_model.dart';

class UserAuth {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  UserAuth({required this.firebaseAuth, required this.firebaseFirestore});

  Future<Either<FirebaseAuthError, UserModel>> userSignUp(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        await firebaseFirestore.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'uid': user.uid,
        });

        return Right(
          UserModel(
            firstName: firstName,
            lastName: lastName,
            email: email,
            uid: user.uid,
          ),
        );
      } else {
        return Left(
          FirebaseAuthError(
            firebaseAuthException: FirebaseException(
              plugin: 'Create account error',
              message: 'Unable to create user account',
            ),
          ),
        );
      }
    } on Exception catch (e) {
      throw 'An unexpected error occured :: $e';
    }
  }
}

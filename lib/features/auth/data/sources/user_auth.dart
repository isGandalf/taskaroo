import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:taskaroo/core/errors/firebase_errors.dart';
import 'package:taskaroo/features/auth/data/model/user_model.dart';

class UserAuth {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  final _logger = Logger();

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
        _logger.d('User created and transferred to Model');
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
            firebaseAuthException: FirebaseAuthException(
              code: 'User Model',
              message: 'User model transfer error when creating user.',
            ),
          ),
        );
      }
    } catch (e) {
      return Left(
        FirebaseAuthError(
          firebaseAuthException: FirebaseException(
            plugin: 'Firebase sign up error',
            message: 'Unexpected error occured during sign up :: $e',
          ),
        ),
      );
    }
  }

  Future<Either<FirebaseAuthError, UserModel>> userLogin(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user == null) {
        return Left(
          FirebaseAuthError(
            firebaseAuthException: FirebaseException(
              plugin: 'No user',
              message: 'No user found',
            ),
          ),
        );
      }

      final DocumentSnapshot<Map<String, dynamic>> userData =
          await firebaseFirestore.collection('users').doc(user.uid).get();
      final dataReceived = userData.data();
      if (dataReceived != null) {
        final userModel = UserModel.fromFirestoreMap(
          dataReceived['firstName'] as String,
          dataReceived['lastName'] as String,
          dataReceived['email'] as String,
          user.uid,
        );
        //_logger.d('Data received and transferred to Model');
        return Right(userModel);
      } else {
        return Left(
          FirebaseAuthError(
            firebaseAuthException: FirebaseAuthException(
              code: 'User Model',
              message: 'User Model transfer error on login authentication',
            ),
          ),
        );
      }
    } catch (el, stackTrace) {
      _logger.e('Firebase login error: $el', stackTrace: stackTrace);
      return Left(
        FirebaseAuthError(
          firebaseAuthException: FirebaseException(
            plugin: 'Firebase login error',
            message: 'Unexpected error occured',
          ),
        ),
      );
    }
  }

  Future<Either<FirebaseAuthError, void>> signOut() async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      //_logger.d('User is null');
      return Left(
        FirebaseAuthError(
          firebaseAuthException: FirebaseException(plugin: 'No user'),
        ),
      );
    } else {
      //_logger.d('${currentUser.email} has been signed out');
      return Right(await firebaseAuth.signOut());
    }
  }

  Future<Either<ResetPasswordError, void>> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      //logger.d('$email sent');
      return Right(null);
    } on FirebaseAuthException catch (e) {
      //logger.d('Failed to reset');
      return Left(
        ResetPasswordError(message: 'Failed to reset password: ${e.message}'),
      );
    }
  }
}

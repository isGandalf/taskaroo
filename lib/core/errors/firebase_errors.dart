/*
* Custom class to handle errors related to Firebase
*/

import 'package:firebase_auth/firebase_auth.dart';

abstract interface class Errors {
  String getError();
}

final class FirebaseAuthError extends Errors {
  final FirebaseException firebaseAuthException;

  FirebaseAuthError({required this.firebaseAuthException});

  @override
  String getError() {
    return firebaseAuthException.message ??
        'An error occurred with Firebase authentication.';
  }
}

final class UserModelError extends Errors {
  final String getErrorMessage;

  UserModelError({required this.getErrorMessage});
  @override
  String getError() {
    return getErrorMessage;
  }
}

final class UserAuthBlocError extends Errors {
  final String getErrorMessage;

  UserAuthBlocError({required this.getErrorMessage});
  @override
  String getError() {
    return getErrorMessage;
  }
}

final class ResetPasswordError extends Errors {
  final String message;

  ResetPasswordError({required this.message});

  @override
  String getError() {
    return message;
  }
}

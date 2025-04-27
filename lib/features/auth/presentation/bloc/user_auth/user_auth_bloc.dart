import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';
import 'package:taskaroo/features/auth/domain/usecases/auth_usecase.dart';

part 'user_auth_event.dart';
part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final AuthUsecase authUsecase;
  final _logger = Logger();

  UserAuthBloc(this.authUsecase) : super(UserAuthInitial()) {
    on<CreateAccountButtonPressedEvent>(createAccountButtonPressedEvent);
    on<SignInButtonPressedEvent>(signInButtonPressedEvent);
    on<SignOutButtonPressedEvent>(signOutButtonPressedEvent);
    on<ResetPasswordButtonPressedEvent>(resetPasswordButtonPressedEvent);
    //on<SignInLinkTextPressed>(signInLinkTextPressed);
    //on<SignUpLinkTextPressed>(signUpLinkTextPressed);
  }

  FutureOr<void> createAccountButtonPressedEvent(
    CreateAccountButtonPressedEvent event,
    Emitter<UserAuthState> emit,
  ) async {
    emit(SignUpButtonClickLoadingState());
    await Future.delayed(Duration(seconds: 2));
    final entity = await authUsecase.userSignUp(
      event.firstName,
      event.lastName,
      event.email,
      event.password,
    );

    return entity.fold(
      ifLeft: (failure) {
        emit(UserAuthFailureState());
      },
      ifRight: (userEntity) {
        emit(UserAuthSuccessState());
      },
    );
  }

  FutureOr<void> signInButtonPressedEvent(
    SignInButtonPressedEvent event,
    Emitter<UserAuthState> emit,
  ) async {
    emit(LogInButtonClickLoadingState());
    final entity = await authUsecase.userLogin(event.email, event.password);

    return entity.fold(
      ifLeft: (failure) {
        _logger.e('Failed to Sign in');
        emit(LoginFailedState());
      },
      ifRight: (userEntity) async {
        _logger.d('Sign in success');
        emit(LoginSuccessState(userEntity: userEntity));
      },
    );
  }

  FutureOr<void> signOutButtonPressedEvent(
    SignOutButtonPressedEvent event,
    Emitter<UserAuthState> emit,
  ) async {
    try {
      await authUsecase.signOut();
      _logger.d('Success sign out');
      emit(SignOutSuccessState());
    } catch (e) {
      _logger.e('Unsuccessful sign out');
      emit(SignOutFailedState());
    }
  }

  FutureOr<void> resetPasswordButtonPressedEvent(
    ResetPasswordButtonPressedEvent event,
    Emitter<UserAuthState> emit,
  ) async {
    try {
      final result = await authUsecase.resetPassword(event.email);
      //Future.delayed(Duration(seconds: 3));
      return result.fold(
        ifLeft:
            (failure) =>
                emit(ResetPasswordFailedState(message: failure.message)),
        ifRight: (result) => emit(ResetPasswordSuccessState()),
      );
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordFailedState(message: e.message.toString()));
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dart_either/dart_either.dart';
import 'package:meta/meta.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';
import 'package:taskaroo/features/auth/domain/usecases/auth_usecase.dart';

part 'user_auth_event.dart';
part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final AuthUsecase authUsecase;

  UserAuthBloc(this.authUsecase) : super(UserAuthInitial()) {
    on<UserAuthPageLoadedEvent>(userAuthPageLoadedEvent);
    on<CreateAccountButtonPressedEvent>(createAccountButtonPressedEvent);
  }
  FutureOr<void> userAuthPageLoadedEvent(
    UserAuthPageLoadedEvent event,
    Emitter<UserAuthState> emit,
  ) {
    emit(UserAuthPageLoadIntialState());
  }

  FutureOr<void> createAccountButtonPressedEvent(
    CreateAccountButtonPressedEvent event,
    Emitter<UserAuthState> emit,
  ) async {
    emit(UserAuthPageLoadingState());
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
        emit(UserAuthSuccessState(entity: userEntity));
      },
    );
  }
}

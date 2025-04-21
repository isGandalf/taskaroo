part of 'user_auth_bloc.dart';

@immutable
sealed class UserAuthState {}

// S I G N   U P
final class UserAuthInitial extends UserAuthState {}

final class UserAuthActionState extends UserAuthState {}

// after button click loading state
final class SignUpButtonClickLoadingState extends UserAuthActionState {}

// upon successful authentication
final class UserAuthSuccessState extends UserAuthActionState {}

// upon failed authentication
final class UserAuthFailureState extends UserAuthActionState {}

// Navigate to sign in page state
final class RedirectToSignInPageState extends UserAuthActionState {}

// // Navigate to sign in page state
// final class RedirectToSignUpPageState extends UserAuthActionState {}

// L O G I N
final class LogInButtonClickLoadingState extends UserAuthActionState {}

final class LoginFailedState extends UserAuthActionState {}

final class LoginSuccessState extends UserAuthActionState {
  final UserEntity userEntity;

  LoginSuccessState({required this.userEntity});
}

// S I G N   O U T
final class SignOutSuccessState extends UserAuthState {}

final class SignOutFailedState extends UserAuthState {}

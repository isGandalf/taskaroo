part of 'user_auth_bloc.dart';

@immutable
sealed class UserAuthEvent {}

final class UserAuthPageLoadedEvent extends UserAuthEvent {}

// account creation event
final class CreateAccountButtonPressedEvent extends UserAuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  CreateAccountButtonPressedEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}

final class SignInLinkTextPressed extends UserAuthEvent {}

// final class SignUpLinkTextPressed extends UserAuthEvent {}

final class SignInButtonPressedEvent extends UserAuthEvent {
  final String email;
  final String password;

  SignInButtonPressedEvent({required this.email, required this.password});
}

// Sign out event

final class SignOutButtonPressedEvent extends UserAuthEvent {}

// reset password
final class ResetPasswordButtonPressedEvent extends UserAuthEvent {
  final String email;

  ResetPasswordButtonPressedEvent({required this.email});
}

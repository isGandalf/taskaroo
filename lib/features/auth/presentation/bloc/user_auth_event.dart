part of 'user_auth_bloc.dart';

@immutable
sealed class UserAuthEvent {}

final class UserAuthPageLoadedEvent extends UserAuthEvent {}

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

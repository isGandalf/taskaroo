part of 'user_auth_bloc.dart';

@immutable
sealed class UserAuthState {}

final class UserAuthInitial extends UserAuthState {}

// initial page load
final class UserAuthPageLoadIntialState extends UserAuthState {}

// after button click loading state
final class UserAuthPageLoadingState extends UserAuthState {}

// upon successful authentication
final class UserAuthSuccessState extends UserAuthState {
  final UserEntity entity;

  UserAuthSuccessState({required this.entity});
}

// upon failed authentication
final class UserAuthFailureState extends UserAuthState {}

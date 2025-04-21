part of 'homepage_bloc.dart';

@immutable
sealed class HomepageState {}

final class HomepageInitial extends HomepageState {}

final class LoadHomepageDataState extends HomepageState {
  final UserEntity userEntity;

  LoadHomepageDataState({required this.userEntity});
}

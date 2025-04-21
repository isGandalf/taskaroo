part of 'homepage_bloc.dart';

@immutable
sealed class HomepageEvent {}

final class LoadHomepageEvent extends HomepageEvent {
  final UserEntity userEntity;

  LoadHomepageEvent({required this.userEntity});
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageInitial()) {
    on<LoadHomepageEvent>(loadHomepageEvent);
  }

  FutureOr<void> loadHomepageEvent(
    LoadHomepageEvent event,
    Emitter<HomepageState> emit,
  ) {
    emit(LoadHomepageDataState(userEntity: event.userEntity));
  }
}

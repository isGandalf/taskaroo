import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';
import 'package:taskaroo/features/auth/presentation/bloc/homepage/bloc/homepage_bloc.dart';
import 'package:taskaroo/features/auth/presentation/pages/homepage_view.dart';
import 'package:taskaroo/features/todo/domain/repository/todo_domain_repository.dart';

class Homepage extends StatelessWidget {
  final UserEntity userEntity;
  final String userId;

  const Homepage({super.key, required this.userEntity, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              HomepageBloc()..add(LoadHomepageEvent(userEntity: userEntity)),
      child: HomepageView(),
    );
  }
}

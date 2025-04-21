import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:taskaroo/features/auth/presentation/bloc/homepage/bloc/homepage_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_login.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';
import 'package:taskaroo/features/auth/presentation/widgets/custom_drawer.dart';
import 'package:taskaroo/features/auth/presentation/widgets/theme_switch.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  final _logger = Logger();
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomepageBloc, HomepageState>(
          listener: (context, state) {},
        ),
        BlocListener<UserAuthBloc, UserAuthState>(
          listener: (context, state) {
            _logger.d('${state.runtimeType}');
            if (state is SignOutSuccessState) {
              showCustomSnackbar(context, 'Signed out', Colors.green.shade800);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => UserLogin()),
                (route) => false,
              );
            } else if (state is SignOutFailedState) {
              showCustomSnackbar(
                context,
                'Signed out failed',
                Colors.red.shade800,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 68, actions: [ThemeSwitch()]),
        drawer: BlocBuilder<HomepageBloc, HomepageState>(
          builder: (context, state) {
            _logger.d('${state.runtimeType}');
            if (state is LoadHomepageDataState) {
              return CustomDrawer(
                state: LoadHomepageDataState(userEntity: state.userEntity),
              );
            } else {
              return Center(child: Text('Unable to load widgets'));
            }
          },
        ),
      ),
    );
  }
}

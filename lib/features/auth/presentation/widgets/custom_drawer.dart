import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/homepage/bloc/homepage_bloc.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';

class CustomDrawer extends StatelessWidget {
  final LoadHomepageDataState state;
  const CustomDrawer({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drawer header
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.blue.shade700,
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${state.userEntity.firstName}',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    'Logged in with ${state.userEntity.email}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Drawer body
          Expanded(
            child: Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          // SignOut
          //Spacer(),
          Container(
            color: Colors.red.shade700,
            child: ListTile(
              title: Text('Sign Out', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.logout, color: Colors.white),
              onTap: () {
                context.read<UserAuthBloc>().add(SignOutButtonPressedEvent());
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taskaroo/core/theme/theme_provider.dart';
import 'package:taskaroo/features/auth/data/respository/user_data_repository.dart';
import 'package:taskaroo/features/auth/data/sources/user_auth.dart';
import 'package:taskaroo/features/auth/domain/repository/user_domain_repository.dart';
import 'package:taskaroo/features/auth/domain/usecases/auth_usecase.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_signup.dart';
import 'package:taskaroo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signOut();

  // dependencies
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final UserAuth userAuth = UserAuth(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
  );
  final UserDomainRepository userDomainRepository = UserDataRepository(
    userAuth: userAuth,
  );
  final AuthUsecase authUsecase = AuthUsecase(
    userDomainRepository: userDomainRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        BlocProvider(create: (context) => UserAuthBloc(authUsecase)),
      ],
      child: const Taskaroo(),
    ),
  );
}

class Taskaroo extends StatelessWidget {
  const Taskaroo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).getCurrentTheme,
      home: UserSignup(),
    );
  }
}

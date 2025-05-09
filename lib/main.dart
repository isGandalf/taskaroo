import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:taskaroo/core/global/global.dart';
import 'package:taskaroo/core/theme/theme_provider.dart';
import 'package:taskaroo/features/auth/data/model/user_model.dart';
import 'package:taskaroo/features/auth/data/respository/user_data_repository.dart';
import 'package:taskaroo/features/auth/data/sources/user_auth.dart';
import 'package:taskaroo/features/auth/domain/entity/user_entity.dart';
import 'package:taskaroo/features/auth/domain/repository/user_domain_repository.dart';
import 'package:taskaroo/features/auth/domain/usecases/auth_usecase.dart';
import 'package:taskaroo/features/auth/presentation/bloc/user_auth/user_auth_bloc.dart';
import 'package:taskaroo/features/auth/presentation/pages/homepage.dart';
import 'package:taskaroo/features/auth/presentation/pages/user_login.dart';
import 'package:taskaroo/features/auth/presentation/widgets/auth_snackbar.dart';
import 'package:taskaroo/features/todo/data/models/todo_model.dart';
import 'package:taskaroo/features/todo/data/repository/shared_todo_data_repository.dart';
import 'package:taskaroo/features/todo/data/repository/todo_data_repository.dart';
import 'package:taskaroo/features/todo/data/source/isar_local_source.dart';
import 'package:taskaroo/features/todo/data/source/isar_shared_todo.dart';
import 'package:taskaroo/features/todo/domain/repository/todo_domain_repository.dart';
import 'package:taskaroo/features/todo/domain/usecase/todo_usecases.dart';
import 'package:taskaroo/features/todo/presentation/bloc/my_todo_bloc/todo_bloc.dart';
import 'package:taskaroo/features/todo/presentation/bloc/shared_todo_bloc/shared_todo_bloc.dart';
import 'package:taskaroo/firebase_options.dart';

/* 
 * The main method will initialize the required packages and frameworks needed for the app to run.
 * Initialize:
 * 1. Firebase   - for user authentication and registration.
 * 2. Firestore  - for saving user details and todo details.
 * 3. Isar       - for storing data in local storage.
 * 4. Clean architecture dependencies.
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*

  F I R E B A S E

  */
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // check if user is signed in
  final currentUser = FirebaseAuth.instance.currentUser;
  final String? userId = currentUser?.uid;

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

  /*  

  I S A R

  */
  // get directory path for storing data and open database
  final directory = await getApplicationDocumentsDirectory();
  final isarDb = await Isar.open([ToDoModelSchema], directory: directory.path);
  logger.d('current user in main: $userId');
  // check current user for isar
  final IsarLocalSource isarLocalSource = IsarLocalSource(
    db: isarDb,
    firebaseFirestore: firebaseFirestore,
  );

  // initialize usecases
  final TodoDomainRepository todoDomainRepository = TodoDataRepository(
    isarLocalSource: isarLocalSource,
  );
  final TodoUsecases todoUsecases = TodoUsecases(
    todoDomainRepository: todoDomainRepository,
  );

  final isarSharedTodo = IsarSharedTodo(
    db: isarDb,
    firebaseFirestore: firebaseFirestore,
  );
  final sharedTodoDomainRepository = SharedTodoDataRepository(
    isarSharedTodo: isarSharedTodo,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        BlocProvider(create: (context) => UserAuthBloc(authUsecase)),
        BlocProvider(create: (context) => TodoBloc(todoUsecases)),
        BlocProvider(
          create: (context) => SharedTodoBloc(sharedTodoDomainRepository),
        ),
      ],
      child: Taskaroo(currentUser: currentUser),
    ),
  );
}

class Taskaroo extends StatelessWidget {
  final User? currentUser;
  const Taskaroo({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().getCurrentTheme,

      /*

      * For login page, check if the user is already logged in using FutureBuilder. If yes, the get current user data from
      * cloud and build the homepage UI. Ensure to map the snapshot data to entity which will be used in the UI.
    
      */
      home:
          currentUser == null
              ? const UserLogin()
              : FutureBuilder(
                future:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser!.uid)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showCustomSnackbar(
                        context,
                        'Error receiving data',
                        Colors.red.shade800,
                      );
                    });
                    return const UserLogin();
                  } else if (snapshot.hasData && snapshot.data!.exists) {
                    final user = snapshot.data!.data() as Map<String, dynamic>;
                    final userModel = UserModel.fromFirestoreMap(
                      user['firstName'],
                      user['lastName'],
                      user['email'],
                      currentUser!.uid,
                    );
                    final userEntity = UserEntity(
                      firstName: userModel.firstName,
                      lastName: userModel.lastName,
                      email: userModel.email,
                      uid: userModel.uid,
                    );
                    return Homepage(
                      userEntity: userEntity,
                      userId: currentUser!.uid,
                    );
                  }
                  return Scaffold(
                    body: const Center(child: Text('No user data available')),
                  );
                },
              ),
    );
  }
}

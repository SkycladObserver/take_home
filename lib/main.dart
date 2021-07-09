import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home/app/bloc/app_bloc.dart';
import 'package:take_home/app/routes/routes.dart';
import 'package:take_home/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepo = AuthRepository();
  await authRepo.user.first;

  runApp(Dependencies(
    authRepository: authRepo,
    child: MyApp(),
  ));
}

/// inject dependencies into tree
class Dependencies extends StatelessWidget {
  const Dependencies(
      {Key? key, required this.authRepository, required this.child})
      : super(key: key);

  final AuthRepository authRepository;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (_) => AppBloc(authRepository: authRepository),
        child: child,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eigital Take Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: routes,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home/login/bloc/login_cubit.dart';
import 'package:take_home/repositories/auth_repository.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: LoginScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(context.read<AuthRepository>()),
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.loginFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('Authentication Failure.')));
            }
          },
          child: _LoginScreenContent(),
        ),
      ),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          FractionallySizedBox(
            child: const SizedBox(height: 100),
            widthFactor: 1,
          ),
          Text("Login"),
          const SizedBox(height: 20),
          _LoginButtons(),
        ],
      ),
    );
  }
}

class _LoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(alignment: Alignment.centerLeft),
        ),
      ),
      child: Flexible(
        child: Column(
          children: [
            _LoginButton(
              label: "Facebook",
              color: Colors.blue,
              icon: Icons.facebook,
              onPressed: () => context.read<LoginCubit>().loginWithFacebook(),
            ),
            _LoginButton(
              label: "Gmail",
              color: Colors.red,
              icon: Icons.mail,
              onPressed: () => context.read<LoginCubit>().loginWithGoogle(),
            ),
            _LoginButton(
              label: "Firebase",
              color: Colors.orange,
              icon: Icons.local_fire_department,
              onPressed: () => context.read<LoginCubit>().loginWithFirebase(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton(
      {Key? key,
      required this.label,
      required this.color,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  final String label;
  final Color color;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .5,
      child: OutlinedButton.icon(
        icon: Icon(icon, color: color),
        label: Text(label, style: TextStyle(color: color)),
        onPressed: () => onPressed(),
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: color)),
        ),
      ),
    );
  }
}

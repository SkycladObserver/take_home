import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:take_home/app/bloc/app_bloc.dart';
import 'package:take_home/home/bloc/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home/home/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: HomeScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => HomeCubit(),
      child: _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.select((HomeCubit cubit) => cubit.state.title),
        ),
      ),
      drawer: _HomeDrawer(),
      body: FlowBuilder<HomeStatus>(
        state: context.select((HomeCubit cubit) => cubit.state.status),
        onGeneratePages: homeRoutes,
      ),
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = context.select((AppBloc bloc) => bloc.currentUser.name);
    final welcomeText =
        'Welcome' + (name == null || name.isEmpty ? '!' : ', $name!');

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ColoredBox(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 0, 20),
                child: Text(welcomeText, style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              title: Text(titleMap),
              onTap: () {
                context.read<HomeCubit>().redirect(HomeStatus.map);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(titleCalculator),
              onTap: () {
                context.read<HomeCubit>().redirect(HomeStatus.calculator);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(titleNewsFeed),
              onTap: () {
                context.read<HomeCubit>().redirect(HomeStatus.newsFeed);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

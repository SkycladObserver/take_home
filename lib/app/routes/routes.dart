import 'package:flutter/cupertino.dart';
import 'package:take_home/app/bloc/app_bloc.dart';
import 'package:take_home/home/view/home_screen.dart';
import 'package:take_home/login/view/login_screen.dart';

List<Page> routes(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomeScreen.page];
    default:
      return [LoginScreen.page];
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

const titleMap = 'Map';
const titleCalculator = 'Calculator';
const titleNewsFeed = 'News Feed';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.map);

  Future<void> redirect(HomeStatus status) async {
    switch (status) {
      case HomeStatus.map:
        emit(HomeState.map);
        break;
      case HomeStatus.calculator:
        emit(HomeState.calculator);
        break;
      case HomeStatus.newsFeed:
        emit(HomeState.newsFeed);
        break;
    }
  }
}

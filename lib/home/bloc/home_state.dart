part of 'home_cubit.dart';

enum HomeStatus { map, calculator, newsFeed }

class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.map, this.title = titleMap});

  static const newsFeed =
      HomeState(status: HomeStatus.newsFeed, title: titleNewsFeed);
  static const map = HomeState(status: HomeStatus.map, title: titleMap);
  static const calculator =
      HomeState(status: HomeStatus.calculator, title: titleCalculator);

  final HomeStatus status;
  final String title;

  @override
  List<Object?> get props => [status];
}

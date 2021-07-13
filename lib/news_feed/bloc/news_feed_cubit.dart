import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home/news_feed/repository/news_feed_repository.dart';
import 'package:webfeed/domain/rss_feed.dart';

part 'news_feed_state.dart';

const String feedUrl = 'https://www.nasa.gov/rss/dyn/lg_image_of_the_day.rss';

class NewsFeedCubit extends Cubit<NewsFeedState> {
  NewsFeedCubit(this._repo)
      : super(NewsFeedState(status: NewsFeedStatus.initial));

  final NewsFeedRepository _repo;

  void retrieveFeed({bool refresh = false}) async {
    Uri url = Uri.parse(feedUrl);

    emit(state.copyWith(status: NewsFeedStatus.loading));

    try {
      final feed = await _repo.retrieveFeed(url, refresh: refresh);
      emit(state.copyWith(status: NewsFeedStatus.loaded, feed: feed));
    } catch (e) {
      emit(state.copyWith(status: NewsFeedStatus.failure));

      // ideally log this, but for POC purposes rethrow is fine to see stacktrace
      // better
      rethrow;
    }
  }
}

part of 'news_feed_cubit.dart';

enum NewsFeedStatus { initial, loading, loaded, failure }
// if feed exists, show feed regardless of NewsFeedStatus.

class NewsFeedState extends Equatable {
  const NewsFeedState({required this.status, this.feed});

  NewsFeedState copyWith({NewsFeedStatus? status, RssFeed? feed}) =>
      NewsFeedState(status: status ?? this.status, feed: feed ?? this.feed);

  final NewsFeedStatus status;
  final RssFeed? feed;

  @override
  List<Object?> get props => [status, feed];
}

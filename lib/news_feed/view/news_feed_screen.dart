import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home/news_feed/bloc/news_feed_cubit.dart';
import 'package:take_home/news_feed/repository/news_feed_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webfeed/domain/rss_feed.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: NewsFeedScreen());

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NewsFeedRepository(),
      child: BlocProvider(
        create: (context) =>
            NewsFeedCubit(context.read<NewsFeedRepository>())..retrieveFeed(),
        child: _NewsFeedScreenContent(),
      ),
    );
  }
}

class _NewsFeedScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.select((NewsFeedCubit cubit) => cubit.state);
    // if feed exists, always show News Feed. Reason: for example if News Feed
    // is refreshed, the current news feed should still be shown
    if (state.feed != null) {
      return _NewsFeedList(feed: state.feed);
    }

    switch (state.status) {
      case NewsFeedStatus.loading:
        return Center(child: CircularProgressIndicator());
      case NewsFeedStatus.failure:
        return _NewsFeedFailure();
      default:
        return const SizedBox();
    }
  }
}

class _NewsFeedList extends StatelessWidget {
  const _NewsFeedList({Key? key, required this.feed}) : super(key: key);

  final RssFeed? feed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: feed!.items!.length,
      itemBuilder: (BuildContext context, int index) {
        final item = feed!.items![index];

        return ListTile(
          title: title(item.title ?? ""),
          subtitle: subtitle(item.description),
          leading: thumbnail(item.enclosure?.url),
          trailing: rightIcon(),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () => openFeed(item.link),
        );
      },
    );
  }

  Future<void> openFeed(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false);
    }
  }

  Widget title(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget subtitle(String? subtitle) {
    if (subtitle == null) {
      return SizedBox(height: 14);
    }

    return Text(
      subtitle.toString(),
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget thumbnail(String? imageUrl) {
    if (imageUrl == null) {
      return SizedBox(height: 50, width: 70);
    }

    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Image.network(
        imageUrl,
        width: 70,
        height: 50,
        cacheWidth: 70,
        cacheHeight: 50,
      ),
    );
  }

  Widget rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }
}

class _NewsFeedFailure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<NewsFeedCubit>().retrieveFeed(refresh: true),
      child: Container(
        child: Center(
          child: Text("Failure retrieving feed. Tap to retry."),
        ),
      ),
    );
  }
}

import 'dart:ffi';

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
        child: _NewsFeedScreenScaffold(),
      ),
    );
  }
}

class _NewsFeedScreenScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.select((NewsFeedCubit cubit) => cubit.state);
    return Scaffold(
      body: _NewsFeedScreenContent(),
      floatingActionButton: FloatingActionButton(
        // refresh feed
        onPressed: () =>
            context.read<NewsFeedCubit>().retrieveFeed(refresh: true),
        child: state.status == NewsFeedStatus.loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.refresh),
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
        return Center(child: const CircularProgressIndicator());
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
          title: _title(item.title ?? ""),
          subtitle: _subtitle(item.description),
          trailing: _trailing(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          onTap: () => _openItem(item.link),
        );
      },
    );
  }

  Future<void> _openItem(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url, forceWebView: false);
    }
  }

  Widget _title(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _subtitle(String? subtitle) {
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

  Widget _trailing() {
    return Icon(
      Icons.chevron_right,
      color: Colors.grey,
      size: 20,
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

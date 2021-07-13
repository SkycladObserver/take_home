import 'package:http/http.dart';
import 'package:take_home/cache/app_session_cache.dart';
import 'package:take_home/cache/cache_consts.dart';
import 'package:webfeed/domain/rss_feed.dart';

class NewsFeedRepository {
  AppSessionCache get cache => AppSessionCache.instance;

  /// [refresh] to get feed from remote
  /// [url] url of feed
  Future<RssFeed> retrieveFeed(Uri url, {bool refresh = false}) async {
    // if there is newsFeed in cache and refresh = false, retrieve from cache.
    if (cache.contains(newsFeedKey) && !refresh) {
      return cache.read(newsFeedKey);
    }

    try {
      final client = Client();
      final resp = await client.get(url);
      final feed = RssFeed.parse(resp.body);

      cache.write(key: newsFeedKey, value: feed);

      return feed;
    } catch (e) {
      print("Failed to retrieve feed.");
      rethrow;
    }
  }
}

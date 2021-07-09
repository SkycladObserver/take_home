import 'package:flutter/material.dart';
import 'package:take_home/calculator/view/calculator_screen.dart';
import 'package:take_home/map/view/map_screen.dart';
import 'package:take_home/home/bloc/home_cubit.dart';
import 'package:take_home/news_feed/view/news_feed_screen.dart';

List<Page> homeRoutes(HomeStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case HomeStatus.newsFeed:
      return [NewsFeedScreen.page];
    case HomeStatus.calculator:
      return [CalculatorScreen.page];
    case HomeStatus.map:
    default:
      return [MapScreen.page];
  }
}

import 'package:flutter/material.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: NewsFeedScreen());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("News Feed screen"),
    );
  }
}

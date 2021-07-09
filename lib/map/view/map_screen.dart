import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: MapScreen());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Map screen"),
    );
  }
}

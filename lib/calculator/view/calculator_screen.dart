import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: CalculatorScreen());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Calculator screen"),
    );
  }
}

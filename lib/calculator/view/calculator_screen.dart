import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:take_home/calculator/bloc/calculator_cubit.dart';

part 'calculator_button.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  static Page get page => const MaterialPage<void>(child: CalculatorScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalculatorCubit>(
      create: (_) => CalculatorCubit(),
      child: _CalculatorScreenContent(),
    );
  }
}

class _CalculatorScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_CalculatorTextField(), _CalcButtonMatrix()],
      ),
    );
  }
}

class _CalculatorTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerRight,
      child: SizedBox(
        child: Text(
          context.select((CalculatorCubit cubit) => cubit.state.expression),
          overflow: TextOverflow.clip,
          maxLines: 1,
          softWrap: false,
          textScaleFactor: 1.5,
        ),
      ),
    );
  }
}

class _CalcButtonMatrix extends StatelessWidget {
  final List<List<Widget>> _matrix = [
    [
      _CalcButton(
        label: Text('AC'),
        onPressed: (context, operation) {
          BlocProvider.of<CalculatorCubit>(context).clear();
        },
      ),
      _CalcButton(
        label: Icon(Icons.chevron_left),
        onPressed: (context, operation) {
          BlocProvider.of<CalculatorCubit>(context).backspace();
        },
      ),
      _CalcButton(operation: '.'),
      _CalcButton(operation: '/')
    ],
    [
      _CalcButton(operation: '7'),
      _CalcButton(operation: '8'),
      _CalcButton(operation: '9'),
      _CalcButton(operation: '*')
    ],
    [
      _CalcButton(operation: '4'),
      _CalcButton(operation: '5'),
      _CalcButton(operation: '6'),
      _CalcButton(operation: '+')
    ],
    [
      _CalcButton(operation: '1'),
      _CalcButton(operation: '2'),
      _CalcButton(operation: '3'),
      _CalcButton(operation: '-')
    ],
    [
      _CalcButton(operation: '0'),
      _CalcButton(operation: '('),
      _CalcButton(operation: ')'),
      _CalcButton(
        label: Text('='),
        onPressed: (context, operation) {
          BlocProvider.of<CalculatorCubit>(context).evaluate();
        },
      )
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: _matrix
            .map((row) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row))
            .toList(),
      ),
    );
  }
}

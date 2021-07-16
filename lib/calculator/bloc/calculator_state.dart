part of 'calculator_cubit.dart';

class CalculatorState extends Equatable {
  const CalculatorState({this.evaluated = false, this.expression = ''});
  final String expression;

  /// a boolean that signifies that the user just evaluated the expression.
  final bool evaluated;

  @override
  List<Object?> get props => [expression, evaluated];

  CalculatorState copyWith({String? expression, bool? evaluated}) =>
      CalculatorState(
          expression: expression ?? this.expression,
          evaluated: evaluated ?? this.evaluated);
}

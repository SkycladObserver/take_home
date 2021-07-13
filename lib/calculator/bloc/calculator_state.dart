part of 'calculator_cubit.dart';

class CalculatorState extends Equatable {
  const CalculatorState({this.expression = ''});
  final String expression;

  @override
  List<Object?> get props => [expression];

  CalculatorState copyWith({String? expression}) =>
      CalculatorState(expression: expression ?? this.expression);
}

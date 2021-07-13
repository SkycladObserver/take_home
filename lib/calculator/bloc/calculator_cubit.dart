import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(const CalculatorState());

  void appendToExpression(String char) {
    emit(state.copyWith(expression: state.expression + char));
  }

  void evaluate() {
    try {
      String result = _evaluate(state.expression);
      result = removeDecimal(double.parse(result)).toString();
      emit(state.copyWith(expression: result));
    } on FormatException {
      print("Format exception. Evaluation not processed.");
    } on RangeError {
      print("Format exception. Evaluation not processed.");
    }
  }

  void clear() {
    emit(state.copyWith(expression: ""));
  }

  void backspace() {
    final exp = state.expression;
    if (exp.isNotEmpty) {
      emit(state.copyWith(expression: exp.substring(0, exp.length - 1)));
    }
  }

  String _evaluate(String toParse) {
    final contextModel = ContextModel();
    final parser = Parser();
    final exp = parser.parse(toParse);
    return exp.evaluate(EvaluationType.REAL, contextModel).toString();
  }

  // removes decimal for double
  num removeDecimal(double val) {
    return val % 1 == 0 ? val.toInt() : val;
  }
}

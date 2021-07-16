import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';

part 'calculator_state.dart';
part 'calc_expression_appender.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit({this.appender = const CalcExpressionAppender()})
      : super(const CalculatorState());

  final CalcExpressionAppender appender;

  void appendToExpression(String char) {
    // if newly evaluated, append with conditions
    final exp = state.evaluated
        ? appender.appendPostEval(state.expression, char)
        : appender.append(state.expression, char);

    // set evaluated = false as well
    emit(state.copyWith(expression: exp, evaluated: false));
  }

  void evaluate() {
    try {
      String result = _evaluate(state.expression);
      result = _removeDecimal(result);
      emit(state.copyWith(expression: result, evaluated: true));
    } on FormatException {
      print("Format exception. Evaluation not processed.");
    } on RangeError {
      print("Format exception. Evaluation not processed.");
    } on StateError catch (e) {
      print(e.message);
    }
  }

  void clear() {
    emit(state.copyWith(expression: "", evaluated: false));
  }

  void backspace() {
    final exp = state.expression;
    if (exp.isNotEmpty) {
      emit(state.copyWith(
          expression: exp.substring(0, exp.length - 1), evaluated: false));
    }
  }

  String _evaluate(String toParse) {
    final contextModel = ContextModel();
    final parser = Parser();
    final exp = parser.parse(toParse);
    return exp.evaluate(EvaluationType.REAL, contextModel).toString();
  }

  // removes decimal for double
  String _removeDecimal(String val) {
    final doubleVal = double.parse(val);
    return (doubleVal % 1 == 0 ? doubleVal.toInt() : doubleVal).toString();
  }
}

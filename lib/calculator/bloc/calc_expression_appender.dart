part of 'calculator_cubit.dart';

/// calculator append logic
class CalcExpressionAppender {
  const CalcExpressionAppender();

  String append(String expression, String toAppend) {
    return expression + toAppend;
  }

  String appendPostEval(String expression, String toAppend) {
    // if toAppend is a number, clear expression and append toAppend
    if (num.tryParse(toAppend) != null) {
      return toAppend;
    }
    // otherwise, simply append
    return append(expression, toAppend);
  }
}

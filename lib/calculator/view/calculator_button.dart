part of 'calculator_screen.dart';

class _CalcButton extends StatelessWidget {
  const _CalcButton({Key? key, this.label, this.onPressed, this.operation})
      : super(key: key);
  final Widget? label;
  final Function(BuildContext, String?)? onPressed;
  final String? operation;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!(context, operation);
          } else if (operation != null) {
            context.read<CalculatorCubit>().appendToExpression(operation!);
          } else {
            // log
            print("No handler for _CalcButton");
          }
        },
        child: label != null ? label! : Text(operation!));
  }
}

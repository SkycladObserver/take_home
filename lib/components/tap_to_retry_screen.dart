import 'package:flutter/widgets.dart';

/// Used for when a feature is in failure state. tap to reset back to a diff state
class TapToRetryScreen extends StatelessWidget {
  const TapToRetryScreen(
      {Key? key, this.content = const SizedBox(), this.onTap})
      : super(key: key);
  final Widget content;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: content,
        ),
      ),
    );
  }
}

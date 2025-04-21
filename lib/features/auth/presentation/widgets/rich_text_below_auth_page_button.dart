import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextBelowAuthPageButton extends StatelessWidget {
  final String leftText;
  final String rightText;
  final TapGestureRecognizer tapGestureRecognizer;
  const RichTextBelowAuthPageButton({
    super.key,
    required this.leftText,
    required this.rightText,
    required this.tapGestureRecognizer,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: leftText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextSpan(
            text: rightText,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.purpleAccent,
              fontWeight: FontWeight.bold,
            ),
            recognizer: tapGestureRecognizer,
          ),
        ],
      ),
    );
  }
}

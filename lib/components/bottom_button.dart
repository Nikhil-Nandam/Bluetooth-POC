import 'package:flutter/material.dart';
import 'package:power_view_2/constants.dart';

// BottomButton is to build custom button with
// few similar properties but different customizable
// options and actions.
class BottomButton extends StatelessWidget {

  // Class fields.
  final String bottomText;
  final VoidCallback onTap;

  // Class Constructor.
  const BottomButton({
    required this.bottomText,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kBottomContainerColour,
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: kBbottomContainerHeight,
        child: Center(
          child: Text(
            bottomText,
            style: kLargeButtonTextStyle,
          ),
        ),
      ),
    );
  }
}

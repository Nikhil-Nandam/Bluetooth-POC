import 'package:flutter/material.dart';
import 'package:power_view_2/constants.dart';

class BottomButton extends StatelessWidget {

  final String bottomText;
  final VoidCallback onTap;

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

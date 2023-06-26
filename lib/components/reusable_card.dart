import 'package:flutter/material.dart';

// ReusableCard is to build custom cards with
// few similar properties but different customizable
// options.
class ReusableCard extends StatelessWidget {

  // Class fields.
  // Card colour.
  final Color? colour;
  // Card child.
  final Widget? cardChild;
  // OnPress functionality.
  final VoidCallback? onPress;

  // Class constructor.
  ReusableCard({
    Key? key,
    this.colour,
    this.cardChild,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: cardChild,
      ),
    );
  }
}
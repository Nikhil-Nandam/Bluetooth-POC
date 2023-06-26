import 'package:flutter/material.dart';
import 'package:power_view_2/constants.dart';

// IconContent is to build icons and label them with
// few similar properties but different customizable
// options.
class IconContent extends StatelessWidget {

  // Class fields.
  final String label;
  final IconData icon;

  // Class Constructor.
  IconContent({
    Key? key,
    required this.icon,
    required this.label
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        SizedBox(
          height: 15.0
        ),
        Text(
          label, 
          style: kLabelTextStyle,
        ),
      ],
    );
  }
}

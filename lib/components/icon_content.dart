import 'package:flutter/material.dart';
import 'package:power_view_2/constants.dart';

class IconContent extends StatelessWidget {
  final String label;
  final IconData icon;

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

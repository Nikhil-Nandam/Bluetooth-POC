import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:power_view_2/constants.dart';
import 'package:power_view_2/components/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:power_view_2/components/bottom_button.dart';

class AirFilter extends StatelessWidget {

  // Class field(s).
  final String airFilter;

  // Class Constructor.
  const AirFilter({
    required this.airFilter,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar.
      appBar: AppBar(
        title: Text('POWERVIEW'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Air Filter',
                style: kTitleTextStyle,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.filter,
                    size: 80.0,
                    color: kNTEYellowColour,
                  ),
                  Text(
                    airFilter,
                    style: kMetricValueTextStyle,
                  ),
                ],
              ),
            ),
          ),
          BottomButton(
            bottomText: 'BACK',
            onTap: () {
              // Pop this page route from the stack
              Navigator.pop(context);
            },
          ),
        ]
      ),
    );
  }
}
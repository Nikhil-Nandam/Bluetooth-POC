import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:power_view_2/constants.dart';
import 'package:power_view_2/components/reusable_card.dart';
import 'package:flutter/material.dart';
import 'package:power_view_2/components/bottom_button.dart';

class SparkPlug extends StatelessWidget {

  // Class field(s).
  final String sparkPlug;

  // Class Constructor.
  const SparkPlug({
    required this.sparkPlug,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top App Bar
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
                'Spark Plug',
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
                    FontAwesomeIcons.plugCircleBolt,
                    size: 80.0,
                    color: kNTEYellowColour,
                  ),
                  Text(
                    sparkPlug,
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
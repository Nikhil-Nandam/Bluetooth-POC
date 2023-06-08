import 'package:flutter/material.dart';

const double kBbottomContainerHeight = 80.0;
const Color kActiveCardColour = Color(0xFF1D1E33);
const Color kInactiveCardColour = Color(0xFF111328);
const Color kBottomContainerColour = Color(0xFFF3B307);

const Color kNTEYellowColour = Color(0xFFF3B307);

const double kMinHeight = 120.0;
const double kMaxHeight = 220.0;

const Color kSliderThumbColour = Color(0xFFF3B307);
const Color kSliderActiveColour = Colors.white;
const Color kSliderOverlayColour = Color(0x29EB1555);
const Color kSliderInactiveColour = Color(0xFF8D8E98);

const Color kRoundedIconButtonColour = Color(0xFF4C4F5E);

const TextStyle kLabelTextStyle = TextStyle(
  fontSize: 25.0, 
  color: Color(0xFFF3B307),
  // color: Colors.white,
);

const TextStyle kNumberTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

const TextStyle kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const TextStyle kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const TextStyle kBMITextStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
  // color: kNTEYellowColour,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: 22.0,
);

enum Gender {
  male,
  female,
  none,
}
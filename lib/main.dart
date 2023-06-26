import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:power_view_2/screens/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

late String deviceName; 
late String deviceVersion;
late String deviceID;

Future<List<String>> getDeviceDetails() async {
  
  // Instantiate a DeviceInfoPlugin to extract device details
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
    // Extract device name, device version and device id
    var build = await deviceInfoPlugin.androidInfo;
    deviceName = build.model;
    deviceVersion = build.version.toString();
    deviceID = build.id;  
  } on PlatformException {
    print('Failed to get platform version');
  }

  return [deviceName, deviceVersion, deviceID];
}

void main() async {

  // Initialize Hive.
  await Hive.initFlutter();

  // Create a box 'myBox' to store data
  // will be accessed later in the application.
  await Hive.openBox<Map<String, dynamic>>('myBox');

  // Runs the application.
  runApp(PowerView());

  // Calling function to extract device information.
  await getDeviceDetails();
}

class PowerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the theme for the entire application.
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
        ),
      ),
      // Displays HomePage UI
      home: HomePage(),
    );
  }
}
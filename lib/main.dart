import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:power_view_2/screens/input_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

late String deviceName; 
late String deviceVersion;
late String deviceID;

Future<List<String>> getDeviceDetails() async {
  // String deviceName;
  // String deviceVersion;
  // String identifier;
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  try {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      deviceID = build.id;  
  } on PlatformException {
    print('Failed to get platform version');
  }

  //if (!mounted) return;
  return [deviceName, deviceVersion, deviceID];
}

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Map<String, dynamic>>('myBox');
  runApp(PowerView());
  await getDeviceDetails();
}

class PowerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
        ),
      ),
      home: InputPage(),
    );
  }
}
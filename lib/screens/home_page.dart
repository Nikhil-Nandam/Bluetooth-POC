// Import required functions and modules
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:power_view_2/components/reusable_card.dart';
import 'package:power_view_2/constants.dart';
import 'package:power_view_2/main.dart';
import 'package:power_view_2/screens/power_output.dart';
import 'package:power_view_2/components/bottom_button.dart';
import 'package:power_view_2/components/icon_content.dart';
import 'package:power_view_2/screens/fuel.dart';
import 'package:power_view_2/screens/air_filter.dart';
import 'package:power_view_2/screens/spark_plug.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

// A class 'GeneratorData' where each data instance can be
// converted into a 'GeneratorData' object.
class GeneratorData {

  // The metrics that are being monitored.
  String fuelLevel;
  String powerOutput;
  String generatorStatus;
  String airFilter;
  String sparkPlug;

  // Class constructor
  GeneratorData({
    required this.fuelLevel,
    required this.powerOutput,
    required this.generatorStatus,
    required this.airFilter,
    required this.sparkPlug
  });

  // Declaration of helper function to create an object of 'GeneratorData' class
  // from JSON formatted string.
  factory GeneratorData.fromJson(Map<String, dynamic> json) => _$GeneratorDataFromJson(json);

  // Declaration of helper function to create JSON formatted string from a 
  // 'GeneratorData' object.
  Map<String, dynamic> toJson() => _$GeneratorDataToJson(this);
}

// Function definition of creating 'GeneratorData' from JSON.
GeneratorData _$GeneratorDataFromJson(Map<String, dynamic> json) => GeneratorData(
  fuelLevel: json['fuelLevel'] as String,
  powerOutput: json['powerOutput'] as String,
  generatorStatus: json['generatorStatus'] as String,
  airFilter: json['airFilter'] as String,
  sparkPlug: json['sparkPlug'] as String,
);

// Function definition of creating JSON from 'GeneratorData' object.
Map<String, dynamic> _$GeneratorDataToJson(GeneratorData instance) => <String, dynamic>{
  'fuelLevel': instance.fuelLevel,
  'powerOutput': instance.powerOutput,
  'generatorStatus': instance.generatorStatus,
  'airFilter': instance.airFilter,
  'sparkPlug': instance.sparkPlug,
};

// 'PersistentStorage' class encapsulates a function that stores generator data
// instances in Hive box 'myBox'.
// Data will be stored in key-value pairs.
// Key will be an int.
// Value will be JSON formatted string containing 5 metrics of
// 'GeneratorData' class. 
class PersistentStorage {

  void storeData(GeneratorData generatorData, int key, var box) async {
    // Store key (int) - value (JSON formatted string).
    box.put('$key', generatorData.toJson());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Instantiate a 'GeneratorData' object with default values.
  GeneratorData data = GeneratorData(
    fuelLevel: '67%',
    powerOutput: '56kW',
    generatorStatus: 'Ready',
    airFilter: '125h',
    sparkPlug: '32%',
  );

  // Instantiate a 'PersistentStorage' object to store data.
  PersistentStorage storage = PersistentStorage();

  // Reference the 'myBox' created in 'main.dart' file.
  var box = Hive.box<Map<String, dynamic>>('myBox');

  // Initialize key for Hive key-value pairs.
  int key = 0;

  // SAS token generation.

  // Statically store the expiry value.
  // Will be replaced dynamically when new token will be created.
  // Expiry in int represents the the number of seconds since epoch that the 
  // SAS token will be valid.
  int expiry = 1687778049;
  
  // Statically store a previously generated signature value.
  // Will be replaced dynamically when new token will be created.
  String signature = 'ietpeBlpSNfaS78mK5q2%2FGiCddBueqavWHr8XMv%2FyMM%3D';
  
  // Parameters to servicebus route.
  // sasName: a default value: 'RootManageSharedAccesskey'.
  String sasName = 'RootManageSharedAccesskey';
  // sbName: name of the event hub namespace.
  String sbName = 'bluetooth-poc-namespace';
  // ehName: name of the event hub within the event hub namespace.
  String ehName = 'bluetooth-poc-event-hub';

  // Function to create a new SAS token.
  // The following code is manually converted from the python version 
  // to dart version for this project.
  // Reference to Microsoft documentation: https://learn.microsoft.com/en-us/rest/api/eventhub/generate-sas-token
  void createNewToken() {
    
    // Define the path to event hub.
    String path = 'https://$sbName.servicebus.windows.net/$ehName';
    String uri = Uri.encodeQueryComponent(path);

    // The variable 'sasKey' is stored in 'constants.dart' file
    // since it's value is a constant.
    List<int> sas = utf8.encode(kSasKey);

    // The expiry of the SAS token will be set to one week (604800 seconds) 
    // from when this code will be executed.
    String newExpiry = ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + 604800).toString();
    List<int> stringToSign = utf8.encode('$uri\n$newExpiry');
    Hmac hmac = Hmac(sha256, sas);
    Digest digest = hmac.convert(stringToSign);
    String base64Mac = base64.encode(digest.bytes);
    String newSignature = Uri.encodeQueryComponent(base64Mac);

    // Update the values of signature and expiry constants.
    signature = newSignature;
    expiry = int.parse(newExpiry);
  }

  // Function to send data to Azure Event Hubs.
  Future<http.Response> sendData(String fuelLevel, String powerOutput, String generatorStatus, String airFilter, String sparkPlug) {
    
    // Condition to check if the token has expired.
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 > expiry) {
      print('YES');
      // If the token has expired, a new token will be created.
      createNewToken();
    }
    // URI: the parameterized connection string to event hubs.
    String uri = 'https://$sbName.servicebus.windows.net/$ehName/messages?timeout=60&api-version=2014-01';
    // String to be included in Authorization header for authentication.
    String sr = 'https://$sbName.servicebus.windows.net/$ehName';
    String srEncoded = Uri.encodeQueryComponent(sr);
    // Convert int to string for string interpolation.
    String expiryString = expiry.toString();

    // HTTP post request
    return http.post(
      Uri.parse(uri),
      // HTTP Headers
      // Authorization header format as specified in Microsoft documentation.
      headers: <String, String>{
        'Content-Type': 'application/atom+xml;type=entry;charset=utf-8',
        'Authorization': 'SharedAccessSignature sr=$srEncoded&sig=$signature&se=$expiryString&skn=$sasName'
      },
      // Body will be data we're sending (i.e) generator data metrics
      // along with mobile device information after encosing in JSON format.
      body: jsonEncode(<String, String>{
        'FuelLevel': fuelLevel,
        'PowerOutput': powerOutput, 
        'GeneratorStatus': generatorStatus, 
        'AirFilter': airFilter,
        'SparkPlug': sparkPlug,
        'DeviceName': deviceName,
        'DeviceVersion': deviceVersion,
        'DeviceID': deviceID,
        }
      )
    );     
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar.
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'POWERVIEW',
          style: TextStyle(
            color: kNTEYellowColour,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  // Fuel Level Data card
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.gasPump,
                      label: data.fuelLevel,
                    ),
                    onPress: () {
                      // Go to Fuel page UI
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FuelLevel(
                            // Passing fuel level value to constructor.
                            fuelLevel: data.fuelLevel,
                          )
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  // PowerOutput Data card
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.plugCircleBolt,
                      label: data.powerOutput,
                    ),
                    onPress: () {
                      // Go to PowerOutput page UI
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PowerOutput(
                            // Passing power output value to constructor.
                            powerOutput: data.powerOutput,
                          )
                        ),
                      );
                    },
                  ),
                ),
              ]
            ),
          ),
          Expanded(
            // GeneratorStatus Data card
            child: ReusableCard(
              colour: kActiveCardColour,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.generatorStatus,
                    style: kTitleTextStyle,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'GENERATOR STATE',
                      style: kLabelTextStyle,
                    ),
                  ),   
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  // AirFilter Data card
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.filter,
                      label: data.airFilter,
                    ),
                    onPress: () {
                      // Go to AirFilter page UI
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AirFilter(
                            // Passing air filter value to constructor.
                            airFilter: data.airFilter,
                          )
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  // SparkPlug Data card
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.bolt,
                      label: data.sparkPlug,
                    ),
                    onPress: () {
                      // Go to SparkPlug page UI
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SparkPlug(
                            // Passing spark plug value to constructor.
                            sparkPlug: data.sparkPlug,
                          )
                        ),
                      );
                    },
                  ),
                ),
              ]
            ),
          ),
          BottomButton(
            bottomText: 'REFRESH',
            onTap: () {
              // Store data in Hive boxes using an instance of 
              // 'PersistentStorage' and passing data and key.
              storage.storeData(data, key, box);

              // Instance of Random to generate random data.
              var random = Random();

              // A test to check if data is actually being stored in Hive.
              print(Hive.box<Map<String, dynamic>>('myBox').get('$key'));

              // Calling the function that sends data to Event Hubs.
              Future<http.Response> response = sendData(
                data.fuelLevel, 
                data.powerOutput, 
                data.generatorStatus, 
                data.airFilter, 
                data.sparkPlug
              );
              // 'setState' function refreshes the widgets that have values that
              // are being updated in the function and leaves the other widgets as is.
              // Instantly refreshes the UI.
              setState(() {
                data.fuelLevel = '${random.nextInt(101)}%';
                data.powerOutput = '${random.nextInt(250)}kW'; 
                data.generatorStatus = 'Running';
                data.airFilter = '${random.nextInt(150)}h';
                data.sparkPlug = '${random.nextInt(101)}%';
                key++;
              });
            },
          ),
        ],
      )
    );
  }
}


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

class GeneratorData {
  String fuelLevel;
  String powerOutput;
  String generatorStatus;
  String airFilter;
  String sparkPlug;

  GeneratorData({
    required this.fuelLevel,
    required this.powerOutput,
    required this.generatorStatus,
    required this.airFilter,
    required this.sparkPlug
  });

  factory GeneratorData.fromJson(Map<String, dynamic> json) => _$GeneratorDataFromJson(json);

  Map<String, dynamic> toJson() => _$GeneratorDataToJson(this);
}

GeneratorData _$GeneratorDataFromJson(Map<String, dynamic> json) => GeneratorData(
  fuelLevel: json['fuelLevel'] as String,
  powerOutput: json['powerOutput'] as String,
  generatorStatus: json['generatorStatus'] as String,
  airFilter: json['airFilter'] as String,
  sparkPlug: json['sparkPlug'] as String,
);

Map<String, dynamic> _$GeneratorDataToJson(GeneratorData instance) => <String, dynamic>{
  'fuelLevel': instance.fuelLevel,
  'powerOutput': instance.powerOutput,
  'generatorStatus': instance.generatorStatus,
  'airFilter': instance.airFilter,
  'sparkPlug': instance.sparkPlug,
};

class PersistentStorage {

  void storeData(GeneratorData generatorData, int key) async {
    var box = Hive.box<Map<String, dynamic>>('myBox');
    box.put('$key', generatorData.toJson());
  }
}

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {

  GeneratorData data = GeneratorData(
    fuelLevel: '67%',
    powerOutput: '56kW',
    generatorStatus: 'Ready',
    airFilter: '125h',
    sparkPlug: '32%',
  );

  PersistentStorage storage = PersistentStorage();

  var box = Hive.box<Map<String, dynamic>>('myBox');

  int key = 0;

  int expiry = 1687778049;
  String signature = 'ietpeBlpSNfaS78mK5q2%2FGiCddBueqavWHr8XMv%2FyMM%3D';

  String sasName = 'RootManageSharedAccesskey';
  String sbName = 'bluetooth-poc-namespace';
  String ehName = 'bluetooth-poc-event-hub';

  void createNewToken() {
    String path = 'https://$sbName.servicebus.windows.net/$ehName';
    String uri = Uri.encodeQueryComponent(path);
    List<int> sas = utf8.encode(sasKey);
    String newExpiry = ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + 604800).toString();
    List<int> stringToSign = utf8.encode('$uri\n$newExpiry');
    Hmac hmac = Hmac(sha256, sas);
    Digest digest = hmac.convert(stringToSign);
    String base64Mac = base64.encode(digest.bytes);
    String newSignature = Uri.encodeQueryComponent(base64Mac);

    signature = newSignature;
    expiry = int.parse(newExpiry);
  }

  Future<http.Response> sendData(String fuelLevel, String powerOutput, String generatorStatus, String airFilter, String sparkPlug) {
    if (DateTime.now().millisecondsSinceEpoch ~/ 1000 > expiry) {
      // print('YES');
      createNewToken();
    }
    String uri = 'https://$sbName.servicebus.windows.net/$ehName/messages?timeout=60&api-version=2014-01';
    String sr = 'https://$sbName.servicebus.windows.net/$ehName';
    String srEncoded = Uri.encodeQueryComponent(sr);
    String expiryString = expiry.toString();
    return http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/atom+xml;type=entry;charset=utf-8',
        'Authorization': 'SharedAccessSignature sr=$srEncoded&sig=$signature&se=$expiryString&skn=$sasName'
      },
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'POWERVIEW',
          style: TextStyle(
            color: Color(0xFFF3B307),
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
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.gasPump,
                      // label: '${data.fuelLevel}%',
                      label: data.fuelLevel,
                    ),
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FuelLevel(
                            fuelLevel: data.fuelLevel,
                          )
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.plugCircleBolt,
                      // label: '${data.powerOutput}kW',
                      label: data.powerOutput,
                    ),
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PowerOutput(
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
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.filter,
                      label: data.airFilter,
                    ),
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AirFilter(
                            airFilter: data.airFilter,
                          )
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    colour: kActiveCardColour,
                    cardChild: IconContent(
                      icon: FontAwesomeIcons.bolt,
                      label: data.sparkPlug,
                    ),
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SparkPlug(
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
              storage.storeData(data, key);
              var random = Random();
              print(Hive.box<Map<String, dynamic>>('myBox').get('$key'));

              Future<http.Response> response = sendData(
                data.fuelLevel, 
                data.powerOutput, 
                data.generatorStatus, 
                data.airFilter, 
                data.sparkPlug
              );

              // if (key > 4) {
              //   int currKey = key % 5;
              //   Map<String, dynamic>? values = Hive.box<Map<String, dynamic>>('myBox').get('$currKey');
              //   if (values != null) {
              //     setState(() {
              //       data = GeneratorData.fromJson(values);
              //     });
              //   }
              //   key++;
              // } else {
                setState(() {
                  data.fuelLevel = '${random.nextInt(101)}%';
                  data.powerOutput = '${random.nextInt(250)}kW'; 
                  data.generatorStatus = 'Ready';
                  data.airFilter = '${random.nextInt(150)}h';
                  data.sparkPlug = '${random.nextInt(101)}%';
                  key++;
                });
              // }
            },
          ),
        ],
      )
    );
  }
}


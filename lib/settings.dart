import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

double speed = 80;
String voiceAccent;
String defaultLang;
bool transNeeded = false;
String translatedLang;

// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: Settings(),
//     );
//   }
// }

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      speed = (prefs.getDouble('speed') ?? 80);
      voiceAccent = (prefs.getString('voiceAccent') ?? "Indian");
      defaultLang = (prefs.getString('defaultLang') ?? "English");
      transNeeded = (prefs.getBool('transNeeded') ?? false);
      translatedLang = (prefs.getString('translatedLang') ?? "English");
    });
  }

  // double speed = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: HexColor('#2f3649'),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'Speed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SliderTheme(
            child: Slider(
              value: speed,
              min: 0,
              max: 100,
              divisions: 20,
              label: speed.toInt().toString(),
              onChanged: (double value) async {
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  speed = value;
                  // prefs.setDouble('speed', speed);
                });
              },
            ),
            data: SliderTheme.of(context).copyWith(
                valueIndicatorColor: HexColor('#ffffff'),
                inactiveTrackColor: HexColor('#adefd1ff'),
              activeTrackColor: HexColor('#ffffff'),
              thumbColor: HexColor('#ffffff'),
              overlayColor: HexColor('#adefd1ff'),
                valueIndicatorTextStyle: TextStyle(
                    color: Colors.black, letterSpacing: 2.0)

            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Voice Accent',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: HexColor('#2f3649'),
                ),
                child:DropdownButton<String>(
                  value: voiceAccent,
                  icon: Icon(
                      Icons.arrow_downward,
                    color: HexColor('#adefd1ff'),
                  ),
                  iconSize: 30,
                  elevation: 16,
                  style: TextStyle(color: HexColor('#adefd1ff')),
                  underline: Container(
                    height: 2,
                    color: HexColor('#adefd1ff'),
                  ),
                  onChanged: (String newValue) async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      voiceAccent = newValue;
                      // prefs.setString('voiceAccent', voiceAccent);
                    });
                  },
                  items: <String>['Indian', 'American', 'British', 'Japanese']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Default Language',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: HexColor('#2f3649'),
                ),
                child: DropdownButton<String>(
                  value: defaultLang,
                  icon: Icon(
                    Icons.arrow_downward,
                      color: HexColor('#adefd1ff'),
                  ),
                  iconSize: 30,
                  elevation: 16,
                  style: TextStyle(color: HexColor('#adefd1ff')),
                  underline: Container(
                    height: 2,
                    color: HexColor('#adefd1ff'),
                  ),
                  onChanged: (String newValue) async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      defaultLang = newValue;
                      // prefs.setString('defaultLang', defaultLang);
                    });
                  },
                  items: <String>['English', 'Hindi', 'Russian', 'Japanese']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Translation',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Theme(
                data: ThemeData(unselectedWidgetColor: HexColor('#ffffff')),
                child: Checkbox(
                    value: transNeeded,
                    activeColor: HexColor('#adefd1ff'),
                    onChanged: (bool newValue) async {
                      // SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() {
                        transNeeded = newValue;
                        // prefs.setBool('transNeeded', transNeeded);
                      });
                      Text('Activate Translation');
                    }),
              ),
              IgnorePointer(
                ignoring: !transNeeded,
                child:Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: HexColor('#2f3649'),
                ),

                child: DropdownButton<String>(
                  value: translatedLang,
                  icon: Icon(Icons.arrow_downward,
                      color: transNeeded ? HexColor('#adefd1ff') : HexColor('#9a939e'),
                  ),
                  iconSize: 30,
                  elevation: 16,
                  style: transNeeded
                      ? TextStyle(color: HexColor('#efd1ff'))
                      : TextStyle(color: HexColor('#9a939e')),
                  underline: Container(
                    height: 2,
                    color: transNeeded ? HexColor('#adefd1ff') : HexColor('#9a939e'),
                  ),
                  onChanged: (String newValue) async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      translatedLang = newValue;
                      // prefs.setString('translatedLang', translatedLang);
                    });
                  },
                  items: <String>['English', 'Hindi', 'Russian', 'Japanese']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
              color: HexColor('#adefd1ff'),
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setString('translatedLang', translatedLang);
                  prefs.setString('defaultLang', defaultLang);
                  prefs.setString('voiceAccent', voiceAccent);
                  prefs.setBool('transNeeded', transNeeded);
                  prefs.setDouble('speed', speed);
                  Fluttertoast.showToast(
                  msg: "Settings Updated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.white,
                  textColor: Colors.black54,
                  fontSize: 16.0);
                  Navigator.pop(context);
                });
              })
        ],
      ),
    );
  }
}

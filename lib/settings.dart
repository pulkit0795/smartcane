import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Slider(
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
                ),
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton<String>(
                value: voiceAccent,
                icon: Icon(Icons.arrow_downward),
                iconSize: 30,
                elevation: 16,
                style: TextStyle(color: Colors.blueAccent),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
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
                ),
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton<String>(
                value: defaultLang,
                icon: Icon(Icons.arrow_downward),
                iconSize: 30,
                elevation: 16,
                style: TextStyle(color: Colors.blueAccent),
                underline: Container(
                  height: 2,
                  color: Colors.blueAccent,
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
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checkbox(
                  value: transNeeded,
                  activeColor: Colors.blueAccent,
                  onChanged: (bool newValue) async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      transNeeded = newValue;
                      // prefs.setBool('transNeeded', transNeeded);
                    });
                    Text('Activate Translation');
                  }),
              IgnorePointer(
                ignoring: !transNeeded,
                child: DropdownButton<String>(
                  value: translatedLang,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 30,
                  elevation: 16,
                  style: transNeeded
                      ? TextStyle(color: Colors.blueAccent)
                      : TextStyle(color: Colors.grey),
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
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
            ],
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
              color: Colors.blue,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                setState(() {
                  prefs.setString('translatedLang', translatedLang);
                  prefs.setString('defaultLang', defaultLang);
                  prefs.setString('voiceAccent', voiceAccent);
                  prefs.setBool('transNeeded', transNeeded);
                  prefs.setDouble('speed', speed);
                });
              })
        ],
      ),
    );
  }
}

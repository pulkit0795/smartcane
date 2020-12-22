import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ocr_app/settings.dart';
import 'package:translator/translator.dart';
import 'package:image/image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pimp_my_button/pimp_my_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/side_nav.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_stack/image_stack.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ocr_app/settings.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:path/path.dart' as Path;

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      debugShowCheckedModeBanner: false,

      title: 'Smart Eyes',
      home: MyHomePage(),
      theme: ThemeData(primaryColor: HexColor('#182035')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  int x = 0;
  String trans;
  String audioFileName;
  String temp = '';
  GoogleTranslator translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();

  File pickedImage;
  bool isImageLoaded = false;

  Future pickImage(bool cam) async {
    var tempStore = cam
        ? await ImagePicker.pickImage(source: ImageSource.camera)
        : await ImagePicker.pickImage(source: ImageSource.gallery);
    print(tempStore);

    setState(() {
      pickedImage =
          tempStore; // picked image wali file ko rotate krna h or fir picked img e hi save kradena h
    });
    if (pickedImage != null) {
      isImageLoaded = true;
    }
  }

  Future readText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool transNeeded = prefs.getBool('transNeeded') ?? false;
    double speechRate = (prefs.getDouble('speed') ?? 80) / 100;
    String vAccent;
    String dLang;
    String trLang;
    switch (prefs.getString('voiceAccent')) {
      case 'Indian':
        vAccent = 'hi-in-x-hia-local';
        break;
      case 'American':
        vAccent = 'es-us-x-sfb-local';
        break;
      case 'British':
        vAccent = 'en-gb-x-gbb-network';
        break;
      case 'Japanese':
        vAccent = 'ja-jp-x-jab-network';
        break;
    }
    switch (prefs.getString('defaultLang')) {
      case 'English':
        dLang = "en-GB";
        break;
      case 'Hindi':
        dLang = "hi-IN";
        break;
      case 'Russian':
        dLang = "ru";
        break;
      case 'Japanese':
        dLang = "ja";
        break;
      default:
        dLang = "en-GB";
        break;
    }
    switch (prefs.getString('translatedLang')) {
      case 'English':
        trLang = "en-GB";
        break;
      case 'Hindi':
        trLang = "hi";
        break;
      case 'Russian':
        trLang = "ru";
        break;
      case 'Japanese':
        trLang = "ja";
        break;
    }

    print('---------Reading the Text---------');
    // String temp = '';
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    int i = 0;

    for (TextBlock block in readText.blocks) {
      temp += '\n';
//      temp+=block.text;
//      temp+=' ';
//      print(i.toString()+'\n');
//      i++;

//      print(block.text);
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          temp.trim();
          temp += word.text;
          temp += ' ';
//            print(temp[temp.length]);

          print(word.text);
        }
      }
    }

    temp = temp.replaceAll(
        '\n', ''); // removes newlines from temp - unnecessary pauses

    var p = await flutterTts.getVoices;
    print(p);
    if (transNeeded) {
      await translator.translate(temp, to: trLang).then((output) {
        setState(() {
          temp = output.toString();
        });
      });
    }
    await flutterTts.setLanguage(dLang);

    // var p = await flutterTts.getVoices;
    // print(p);
//    await flutterTts.setVoice('hi-in-x-hid-network');

//     await flutterTts.setVoice(vAccent);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.speak(temp);
//    await flutterTts.synthesizeToFile(temp, '1staudio.mp4');

    print(temp);
  }

  SaveFile() async {
    await flutterTts.synthesizeToFile(temp, audioFileName + '.mp4');

    File file = File(
        '/storage/emulated/0/Android/data/com.webdevwithus.flutter_app/files/' +
                audioFileName ??
            '1staudio' + '.mp4');
  }

  Translate(temp, String tLang) async {
    print('translating...');
    await translator.translate(temp, to: tLang).then((output) {
      setState(() {
        trans = output.toString();
      });
    });
    print('hello done');
  }

  RotateImg() {
    setState(() {
      var image = decodeImage(pickedImage.readAsBytesSync());
      var thumbnail = copyRotate(image, 90);
      pickedImage.writeAsBytesSync(encodePng(thumbnail));
      x += 1;
    });
  }

  final myController = TextEditingController();

  @override
  void disposeText() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: myController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter File Name',
                    hintText: 'The Alchemist\'s AudioBook'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('DONE'),
              onPressed: () {
                audioFileName = myController.text;
                myController.text = '';
                // myController.dispose();
                Navigator.pop(context);
                SaveFile();
                Fluttertoast.showToast(
                    msg: "File Saved",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM_LEFT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black54,
                    fontSize: 16.0);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    List<String> images = [
      "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
    ];

    print("build is called $x");
    return Scaffold(
      drawer: NavDrawer(context, 0),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Smart Cane',
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
              // Settings();
              // do something
            },
          )
        ],
        backgroundColor: HexColor('#182035'),
        elevation: 0,
      ),
      backgroundColor: HexColor('#182035'),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              isImageLoaded
                  ? Center(
                      child: RotatedBox(
                      quarterTurns: x,
                      child: Container(
                        width: (size / 1.15) - 40,
                        height: (size / controller.value.aspectRatio) - 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: FileImage(pickedImage),
                                fit: BoxFit.fill)),
                      ),
                    ))
                  : ClipRect(
                      // child: FittedBox(
                      //     fit: BoxFit.fitWidth,
                      //     child: Container(
                      //         width: size / 1.15,
                      //         height: (size / controller.value.aspectRatio),
                      //         child: AspectRatio(
                      //           aspectRatio: controller.value.aspectRatio,
                      //           child: CameraPreview(controller),
                      //         ))),
                      ),
              SizedBox(
                height: 10,
              ),
              isImageLoaded
                  ? IconButton(
                      color: HexColor('#161D2F'),
                      hoverColor: HexColor('#182035'),
                      splashColor: Colors.white70,
                      icon: Icon(
                        Icons.rotate_90_degrees_ccw,
                        size: 20,
                        color: Colors.white,
                      ),
                      onPressed: RotateImg,
                    )
                  : Container(),
              RaisedButton(
                elevation: 6,
                color: HexColor('#161D2F'),
                hoverColor: HexColor('#182035'),
                splashColor: Colors.white70,
                child: Text(
                  'Choose Image',
                  style: TextStyle(
                      fontSize: 15, letterSpacing: 2, color: Colors.white),
                ),
                onPressed: () {
                  print('heyyyyyyy');
                  pickImage(false);
                  // setState(() {
                  //   print('hey');
                  //   isImageLoaded = true;
                  //   pickedImage=File('/data/user/0/com.webdevwithus.ocr_app/cache/image_picker5960057178698883867.jpg');
                  // },
                  // );
                },
                onLongPress: () {
                  pickImage(true);
                },
              ),
              SizedBox(
                height: 10,
              ),
              isImageLoaded
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PimpedButton(
                          particle: DemoParticle(),
                          pimpedWidgetBuilder: (context, controller) {
                            return RaisedButton(
                              onPressed: () {
                                controller.forward(from: 0.0);
                                readText();
                              },
                              elevation: 6,
                              color: HexColor('#161D2F'),
                              hoverColor: HexColor('#182035'),
                              splashColor: Colors.white70,
                              child: Text(
                                'Speak Up',
                                style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 2,
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                        PimpedButton(
                          particle: DemoParticle(),
                          pimpedWidgetBuilder: (context, controller) {
                            return RaisedButton(
                              onPressed: () async {
                                await _showDialog();
                                controller.forward(from: 0.0);
                              },
                              elevation: 6,
                              color: HexColor('#161D2F'),
                              hoverColor: HexColor('#182035'),
                              splashColor: Colors.white70,
                              child: Text(
                                'Save File',
                                style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 2,
                                    color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Container(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     ImageStack(
              //       imageList: images,
              //       imageRadius: 50, // Radius of each images
              //       imageCount:
              //           8, // Maximum number of images to be shown in stack
              //       imageBorderWidth: 3,
              //       totalCount: 12, // Border width around the images
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
//      floatingActionButton: FabCircularMenu(
//          fabCloseColor: Colors.white,
//          fabColor: HexColor('#112250') ,
//          fabOpenColor: Colors.white,
//          ringColor: HexColor('#2F3C60'),
//
//
//          fabOpenIcon: Icon(Icons.dashboard, color:HexColor('#112250') ),
//          children: <Widget>[
//            IconButton(icon: Icon(Icons.record_voice_over, color: Colors.white, size: 35,), onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context) => settings()));
//              print('Home');
//            }),
////            IconButton(icon: Icon(Icons.airplanemode_active, color: Colors.white, size: 35,), onPressed: () {
////              Navigator.push(context, MaterialPageRoute(builder: (context) => My2Page()));
////              print('Home');
////            }),
//            IconButton(icon: Icon(Icons.colorize, color: Colors.white, size: 35,), onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context) => My3Page()));
//              print('Home');
//            }),
//
//            IconButton(icon: Icon(Icons.person, color: Colors.white, size: 35,), onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context) => My4app()));
//              print('Home');
//            }),
//
//
//          ]
//      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

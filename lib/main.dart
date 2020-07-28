import 'dart:convert';
import 'dart:io';
import 'package:device_id/device_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:login_mod/Constants.dart';
import 'package:login_mod/change_password_page.dart';
import 'package:login_mod/login_data.dart';
import 'package:login_mod/mobile_login.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Country _selected;
  Future<Login> _futureLogin;
  final myController = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void initState() {
    super.initState();
    getDeviceId();
  }

  Future<void> getDeviceId() async {
    Constants.deviceId = await DeviceId.getID;
    print(Constants.deviceId);
    firebaseCloudMessaging_Listeners();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<Login>(
            future: _futureLogin,
            // ignore: missing_return
            builder: (context, snapshot) => handleSnapshot(snapshot)),
        // return CircularProgressIndicator();
      ),
    );
  }

  mobileNumView() => Container(
        height: 60,
        child: Row(
          children: <Widget>[
            Container(
              child: CountryPicker(
                showDialingCode: true,
                showName: false,
                onChanged: (Country country) {
                  setState(() {
                    _selected = country;
                  });
                },
                selectedCountry: _selected,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Builder(
                builder: (context) => TextField(
                  textAlign: TextAlign.start,
                  controller: myController,
                  focusNode: FocusNode(),
                  readOnly: true,
                  enableInteractiveSelection: false,
                  decoration: new InputDecoration(
                    hintText: 'Enter mobile number',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: MobileLoginPage()));
                  },
                ),
              ),
            ),
          ],
        ),
      );

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  // ignore: missing_return
  Widget handleSnapshot(AsyncSnapshot<Login> snapshot) {
    print('handleSnapshot $snapshot ${snapshot.connectionState}');
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        print(snapshot.data);
        // return AlertDialog(
        //   content: Text(snapshot.data.message),
        // );
        print(snapshot.data.message);
        break;
      case ConnectionState.none:
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Image(
                image: AssetImage('images/uber.jpeg'),
                fit: BoxFit.fill,
              )),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Get moving with Uber',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    mobileNumView(),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      height: 1.0,
                      color: Colors.grey,
                      indent: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FlatButton(
                        child: Text(
                          'or connect with social',
                          style: TextStyle(color: Colors.blue),
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
        break;
      default:
        return CircularProgressIndicator();
    }
  }
}

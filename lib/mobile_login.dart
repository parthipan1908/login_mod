import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:login_mod/otp_page.dart';
import 'package:login_mod/password_page.dart';
import 'package:page_transition/page_transition.dart';

import 'Constants.dart';
import 'login_data.dart';
import 'webservice.dart';

class MobileLoginPage extends StatefulWidget {
  static const routeName = '/mobile_login';
  @override
  _MobileLoginPageState createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
  Country _selected;
  Future<Login> _futureLogin;
  bool showLoader = false;
  bool isCountrySelected = false;
  final myController = TextEditingController();

  void initState() {
    super.initState();
    showLoader = false;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    showLoader = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                      child: Text(
                    'Please verify your mobile number,in case we need to get in touch with you during a delivery',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  mobileNumView(),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          if (myController.text == "") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                      content: new Text(
                                          "Please enter your mobile number"),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          child: Text("OK"),
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop("Discard");
                                          },
                                        )
                                      ],
                                    ));
                          } else {
                            callLogin();
                            showLoader = true;
                            Future.delayed(
                                new Duration(seconds: 4), stopLoader);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightGreen,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('(OR)'),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: 200,
                    child: FlatButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        'Join us with facebook',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    height: 100,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Center(child: showLoader ? CircularProgressIndicator() : SizedBox())
          ],
        ),
      ),
    );
  }

  mobileNumView() => Container(
        padding: EdgeInsets.all(20),
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
                    isCountrySelected = true;
                  });
                },
                selectedCountry: _selected,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                textAlign: TextAlign.start,
                controller: myController,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  hintText: 'Enter mobile number',
                  labelStyle: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );

  void callLogin() async {
    loginDetails(
      Resource(
        url: '${BaseUrl}mverifyPhone',
        request: loginRequestToJson(
          LoginRequest(
              countryCode:
                  isCountrySelected ? "+${_selected.dialingCode}" : "+1",
              deviceId: Constants.deviceId,
              deviceToken: Constants.deviceToken,
              deviceType: "3",
              facebookId: "",
              isFacebookLogin: false,
              language: "en",
              phoneNumber: myController.text),
        ),
      ),
    ).then((value) {
      if (value.status == 1) {
        print(value.details);
        Navigator.push(
            context,
            PageTransition(
                child: PasswordPage(logindetail: value.details),
                type: PageTransitionType.rightToLeftWithFade));
        return const SizedBox.shrink();
      } else if (value.status == 2) {
        Navigator.push(
            context,
            PageTransition(
                child: OtpPage(logindetail: value.details),
                type: PageTransitionType.leftToRightWithFade));
        return const SizedBox.shrink();
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
                  content: new Text(value.message),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop("Discard");
                      },
                    )
                  ],
                ));
      }
    });
  }

  Future stopLoader() async {
    setState(() {
      showLoader = false;
    });
  }

  handleSnapshot(AsyncSnapshot<Login> snapshot) {
    print('handleSnapshot $snapshot ${snapshot.connectionState}');
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        print(snapshot.data);

        print(snapshot.data.details);
        if (snapshot.data.status == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PasswordPage(logindetail: snapshot.data.details)));
          return const SizedBox.shrink();
        } else if (snapshot.data.status == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpPage(
                        isforgotOtp: false,
                      )));
          return const SizedBox.shrink();
        } else {
          return AlertDialog(
            content: Text(snapshot.data.message),
          );
        }

        break;
      case ConnectionState.none:
        break;
      default:
        return CircularProgressIndicator();
    }
  }
}

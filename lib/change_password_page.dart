import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_mod/dashbord_page.dart';
import 'package:login_mod/forgot_password_data.dart';
import 'package:login_mod/main.dart';
import 'package:login_mod/mobile_login.dart';
import 'package:login_mod/password_check_data.dart';
import 'package:login_mod/webservice.dart';
import 'package:page_transition/page_transition.dart';

import 'Constants.dart';

class ChangePAsswordPage extends StatefulWidget {
  final ForgotOtpResponse otpResponse;

  const ChangePAsswordPage({Key key, this.otpResponse}) : super(key: key);
  @override
  _ChangePAsswordPageState createState() => _ChangePAsswordPageState();
}

class _ChangePAsswordPageState extends State<ChangePAsswordPage> {
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  bool _showHidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[300],
        elevation: 0.0,
        title: Text('Change Password'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'New Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 5),
            SizedBox(
              height: 40,
              child: TextField(
                controller: newPassword,
                obscureText: _showHidePassword,
                decoration: new InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Icon(
                          _showHidePassword ? Icons.cloud_off : Icons.cloud),
                      onTap: () {
                        setState(() {
                          _showHidePassword = !_showHidePassword;
                        });
                      },
                    ),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(2.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Confirm Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 40,
              child: TextField(
                controller: confirmPassword,
                obscureText: _showHidePassword,
                decoration: new InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Icon(
                          _showHidePassword ? Icons.cloud_off : Icons.cloud),
                      onTap: () {
                        setState(() {
                          _showHidePassword = !_showHidePassword;
                        });
                      },
                    ),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(2.0),
                    ),
                    borderSide: new BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: 250,
                color: Colors.lightGreen,
                child: FlatButton(
                  onPressed: () {
                    if (newPassword.text == confirmPassword.text) {
                      changePasswordApi();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CupertinoAlertDialog(
                                content: new Text(
                                    'Password and Confirm password doesnot match'),
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
                  },
                  child: Text('Submit'),
                  color: Colors.lightGreen,
                ))
          ],
        ),
      ),
    );
  }

  final PageRouteBuilder _homeRoute = new PageRouteBuilder(
    pageBuilder: (BuildContext context, _, __) {
      return MyApp();
    },
  );

  void changePasswordApi() {
    passwordChange(Resource(
      url: '${BaseUrl}mupdateNewPassword',
      request: changePasswordRequestToJson(
        ChangePasswordRequest(
          userId: "",
          language: "en",
          newPassword: newPassword.text,
          retypePassword: confirmPassword.text,
          userUnique: widget.otpResponse.userUnique,
          deviceType: "3",
          deviceToken: Constants.deviceToken,
          deviceId: Constants.deviceId,
        ),
      ),
    )).then((value) {
      if (value.status == 1) {
        Navigator.pushAndRemoveUntil(context, _homeRoute, (route) => false);
        Navigator.push(
            context,
            PageTransition(
                child: MobileLoginPage(), type: PageTransitionType.scale));
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
      print(value);
    });
  }
}

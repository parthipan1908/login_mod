import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_mod/Constants.dart';
import 'package:login_mod/dashbord_page.dart';
import 'package:login_mod/forgot_password_data.dart';
import 'package:login_mod/login_data.dart';
import 'package:login_mod/mobile_login.dart';
import 'package:login_mod/otp_page.dart';
import 'package:login_mod/password_check_data.dart';
import 'package:login_mod/webservice.dart';
import 'package:page_transition/page_transition.dart';

class PasswordPage extends StatefulWidget {
  final LoginDetails logindetail;
  PasswordPage({Key key, @required this.logindetail}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  Future<CheckPasswordResponse> _checkPassword;
  final myController = TextEditingController();
  bool showLoader = false;
  bool _showHidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Weclome back,Sign in to Continue',
                          style: TextStyle(fontSize: 18))),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: myController,
                    obscureText: _showHidePassword,
                    decoration: InputDecoration(
                        hintText: 'Enter Password',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            child: Icon(_showHidePassword
                                ? Icons.cloud_off
                                : Icons.cloud),
                            onTap: () {
                              setState(() {
                                _showHidePassword = !_showHidePassword;
                              });
                            },
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoAlertDialog(
                                    title: Text(
                                      'Forgot Password?',
                                    ),
                                    content: Text(
                                        'To update new password.Confirm Otp send to ${widget.logindetail.countryCode} - ${widget.logindetail.phoneNumber}'),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop("Discard");
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        child: Text("Proceed"),
                                        onPressed: () {
                                          forgotPasswordApi();
                                        },
                                      )
                                    ],
                                  ));
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                              color: Colors.lightGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: 200,
                      child: FlatButton(
                        onPressed: () {
                          if (myController.text == "") {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                      content: new Text(
                                          'Password Field is Empty..Please enter the password'),
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
                          } else if (myController.text.length < 6) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                      content: new Text(
                                          'Please enter atleast 6 digit password'),
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
                            setState(() {
                              showLoader = true;
                              Future.delayed(
                                  new Duration(seconds: 4), stopLoader);
                              checkPasswordApi();
                            });
                          }
                        },
                        child: Text('Submit'),
                        color: Colors.greenAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Center(child: showLoader ? CircularProgressIndicator() : SizedBox())
          ],
        ));
  }

  Future stopLoader() async {
    setState(() {
      showLoader = false;
    });
  }

  void forgotPasswordApi() {
    forgotPassword(Resource(
      url: '${BaseUrl}mforgotPassword',
      request: forgotpasswordRequestToJson(
        ForgotPasswordRequest(
          phoneNumber: widget.logindetail.phoneNumber,
          language: "en",
          countryCode: widget.logindetail.countryCode,
          deviceType: "3",
        ),
      ),
    )).then((value) {
      if (value.status == 1) {
        Navigator.push(
            context,
            PageTransition(
                child: OtpPage(
                  logindetail: widget.logindetail,
                  isforgotOtp: true,
                  fpResponse: value,
                ),
                type: PageTransitionType.rightToLeftWithFade));
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

  void checkPasswordApi() {
    passwordCheckDetails(Resource(
      url: '${BaseUrl}mverifyPassword',
      request: checkPasswordRequestToJson(
        CheckPasswordRequest(
          userId: widget.logindetail.userId,
          phoneNumber: widget.logindetail.phoneNumber,
          userPassword: myController.text,
          language: "en",
          countryCode: widget.logindetail.countryCode,
          deviceType: "3",
          deviceToken: Constants.deviceToken,
          deviceId: Constants.deviceId,
        ),
      ),
    )).then((value) {
      if (value.status == 1) {
        Navigator.push(
            context,
            PageTransition(
                child: DashboardPage(details: value.details),
                type: PageTransitionType.scale));
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

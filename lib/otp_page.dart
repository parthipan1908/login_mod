import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_mod/change_password_page.dart';
import 'package:login_mod/forgot_password_data.dart';
import 'package:login_mod/login_data.dart';
import 'package:login_mod/otpVerify_data.dart';
import 'package:login_mod/signupscreen.dart';
import 'package:login_mod/webservice.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

import 'Constants.dart';

class OtpPage extends StatefulWidget {
  final LoginDetails logindetail;
  final ForgotPasswordResponse fpResponse;
  final bool isforgotOtp;
  OtpPage(
      {Key key, @required this.logindetail, this.fpResponse, this.isforgotOtp})
      : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  Timer _timer;
  int _start = 30;
  bool showLoader = false;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.grey,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Text(
                      'We have send a code to ${widget.logindetail.countryCode} ${widget.logindetail.phoneNumber}\n Please enter below code',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PinEntryTextField(
                      onSubmit: (String pin) {
                        setState(() {
                          widget.isforgotOtp
                              ? forgotOtpApi(pin)
                              : otpRequestApi(pin, 'msignupOtpVerify');
                          showLoader = true;
                          Future.delayed(new Duration(seconds: 4), stopLoader);
                        });
                      }, // end onSubmit
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                setState(() {
                                  _start = 30;
                                  startTimer();
                                  otpRequestApi("", 'mresendOtp');
                                  showLoader = true;
                                  Future.delayed(
                                      new Duration(seconds: 4), stopLoader);
                                });
                              },
                              child: Text(
                                'Resend code',
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                            ),
                            Text('00:$_start',
                                style: TextStyle(color: Colors.lightGreen))
                          ],
                        )),
                    // Container(
                    //     padding: EdgeInsets.all(20),
                    //     child: Center(
                    //       child: FlatButton(
                    //           onPressed: () {},
                    //           child: Text('Submit'),
                    //           color: Colors.lightBlueAccent),
                    //     )
                    //     )
                  ],
                ),
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

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void forgotOtpApi(String otpValue) {
    forgotOtp(
      Resource(
        url: '${BaseUrl}mforgotOtp',
        request: forgotOtpRequestToJson(
          ForgotOtpRequest(
              deviceType: "3",
              otpUnique: widget.fpResponse.otpUnique,
              userId: "",
              language: "en",
              otp: otpValue),
        ),
      ),
    ).then((value) {
      if (value.status == 1) {
        Navigator.push(
            context,
            PageTransition(
                child: ChangePAsswordPage(
                  otpResponse: value,
                ),
                type: PageTransitionType.leftToRight));
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

  void otpRequestApi(String otpValue, String api) async {
    otpVerify(
      Resource(
        url: '${BaseUrl}$api',
        request: otpVerifyToJson(
          OtpRequest(
              deviceType: "3",
              phoneNumber: widget.logindetail.phoneNumber,
              countryCode: widget.logindetail.countryCode,
              language: "en",
              otp: otpValue),
        ),
      ),
    ).then((value) {
      if (value.status == 1 && api == 'msignupOtpVerify') {
        Navigator.push(
            context,
            PageTransition(
                child: SignupScreen(details: value.details),
                type: PageTransitionType.upToDown));
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
}

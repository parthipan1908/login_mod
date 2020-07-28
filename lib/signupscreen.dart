import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_mod/Constants.dart';
import 'package:login_mod/dashbord_page.dart';
import 'package:login_mod/otpVerify_data.dart';
import 'package:login_mod/signup_data.dart';
import 'package:login_mod/webservice.dart';

class SignupScreen extends StatefulWidget {
  final OtpVerifyDetails details;
  SignupScreen({Key key, this.details}) : super(key: key);
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool showLoader = false;
  List<String> placeholderArray = [
    'Phone Number',
    'Email',
    'User Name',
    'Last Name',
    'Password'
  ];
  List<String> textFieldValues = ["", "", "", "", ""];
  bool _showHidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.grey,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[signupView(context), bottomView(context)],
            ),
            Center(child: showLoader ? CircularProgressIndicator() : SizedBox())
          ],
        ));
  }

  Widget signupView(BuildContext context) {
    double statusHeight = MediaQuery.of(context).padding.top;
    // print("STatus height: $statusHeight");
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: statusHeight),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                titleView(context),
                SizedBox(height: 20),
                formView(context),
                SizedBox(height: 20),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget titleView(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("One more step to join with us",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.account_box,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }

  void signupApi() async {
    signupNew(Resource(
      url: '${BaseUrl}msignupNew',
      request: signupRequestToJson(
        SignupRequest(
            deviceId: Constants.deviceId,
            deviceToken: Constants.deviceToken,
            userName: textFieldValues[2],
            lastName: textFieldValues[3],
            phoneNumber: textFieldValues[0],
            userEmail: textFieldValues[1],
            language: "en",
            password: textFieldValues[4],
            countryCode: widget.details.countryCode,
            deviceType: "3",
            loginType: "2",
            userType: "3",
            termsCondition: "1",
            referral: "",
            gender: "M"),
      ),
    )).then((value) {
      if (value.status == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
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

  Widget formView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return index == placeholderArray.length - 1
            ? Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.black),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        textFieldValues[index] = value;
                      });
                    },
                    obscureText: index == placeholderArray.length - 1
                        ? _showHidePassword
                        : false,
                    decoration: InputDecoration(
                        labelText: placeholderArray[index],
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
                ),
                height: 70,
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.black),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        textFieldValues[index] = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: placeholderArray[index],
                        labelStyle: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
                height: 70,
              );
      },
      itemCount: placeholderArray.length,
    );
  }

  Widget bottomView(BuildContext context) {
    //print("Bottom: ${MediaQuery.of(context).size.height >= 812 ? 34 : 0}");
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height >= 812 ? 34 : 0),
      //height: 100,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(20),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: "By clicking you agree to our terms and conditions"),
                TextSpan(text: " "),
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      print("Terms clicked");
                    },
                )
              ]))),
          SizedBox(
            width: 5,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                print("Given Values : $textFieldValues");
                setState(() {
                  signupApi();
                  showLoader = true;
                  Future.delayed(new Duration(seconds: 4), stopLoader);
                });
              },
              child: Container(
                height: 50,
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Submit".toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

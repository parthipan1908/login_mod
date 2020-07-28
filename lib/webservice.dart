import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:login_mod/forgot_password_data.dart';
import 'package:login_mod/otpVerify_data.dart';
import 'package:login_mod/password_check_data.dart';
import 'package:login_mod/signup_data.dart';
import 'login_data.dart';

class Resource<T> {
  final String url;
  final String request;
  T Function(Response response) parse;

  Resource({this.url, this.request, this.parse});
}

Future<Login> loginDetails<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(resource.url,
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return loginFromJson(response.body);
}

Future<CheckPasswordResponse> passwordCheckDetails<T>(
    Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(resource.url,
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return checkPasswordFromJson(response.body);
}

Future<OtpVerify> otpVerify<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(resource.url,
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return otpVerifyFromJson(response.body);
}

Future<SignupResponse> signupNew<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(resource.url,
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return signupFromJson(response.body);
}

Future<ForgotPasswordResponse> forgotPassword<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(resource.url,
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return forgotpasswordFromJson(response.body);
}

Future<ForgotOtpResponse> forgotOtp<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(resource.url,
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return forgotOtpFromJson(response.body);
}

Future<CheckPasswordResponse> passwordChange<T>(Resource<T> resource) async {
  print('request params ${resource.request} ** ${resource.url}');
  final response = await http.post(resource.url,
      headers: _defaultApiHeaders, body: resource.request);
  print("Response body: ${response.body}");
  return checkPasswordFromJson(response.body);
}

var _defaultApiHeaders = {
  HttpHeaders.contentTypeHeader: 'application/json',
  HttpHeaders.authorizationHeader: '',
  'api-token': 'dGhpc2lzYWNvbW1vbnRva2VuXzE='
};

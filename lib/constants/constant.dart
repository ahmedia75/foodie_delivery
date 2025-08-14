// Form Error
import 'package:flutter/widgets.dart';

final RegExp phoneValidatorRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
final RegExp postcodeValidatorRegExp = RegExp(
    r'(^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$)');
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordValidatorRegExp =
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
final RegExp nameValidatorRegExp = RegExp(r"^[aA-zZ\s]+$");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const kAnimationDuration = Duration(milliseconds: 200);
const sliderAnimationDuration = Duration(milliseconds: 500);
const Text loading = Text("loading....");

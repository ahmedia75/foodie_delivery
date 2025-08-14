// ignore_for_file: avoid_print

import 'constant.dart';

class Validator {
  bool? isRequired = true;
  int? maxLength;
  int? minLength;
  bool? isPassword = false;
  bool? isEmail = false;
  bool? isAlphabetOnly = false;
  bool? isNumericOnly = false;
  Comparator? comparator;
  Validator(
      {this.isRequired,
      this.maxLength,
      this.minLength,
      this.isPassword,
      this.isAlphabetOnly,
      this.isEmail,
      this.isNumericOnly,
      this.comparator});

  String? valid(String? value) {
    String? result;
    if (isRequired!) {
      if (value!.isEmpty) {
        return "Required";
      }

      if (maxLength != null && value.length > maxLength!) {
        return "Maximum length existed";
      }

      if (minLength != null && value.length < minLength!) {
        return 'atleat minmum length $minLength';
      }

      if (isPassword != null &&
          isPassword! &&
          !passwordValidatorRegExp.hasMatch(value)) {
        return "Not valid password";
      }

      if (isEmail != null &&
          isEmail! &&
          !emailValidatorRegExp.hasMatch(value)) {
        return "not valid email";
      }
      if (isAlphabetOnly != null &&
          isAlphabetOnly! &&
          !nameValidatorRegExp.hasMatch(value)) {
        return "AlphabetOnly";
      }
      if (isNumericOnly != null &&
          isNumericOnly! &&
          !phoneValidatorRegExp.hasMatch(value)) {
        print(isNumericOnly);
        return "NumericOnly";
      }

      if (comparator != null && comparator!.value != null) {
        if (value != comparator!.value) {
          return comparator!.errorText;
        }
      }
    }

    return result;
  }
}

class Comparator {
  String? value;
  String? errorText;
  Comparator({this.value, this.errorText});
}

import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

enum PasswordValidationError {
  tooShort,
  empty,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  static const int _minLength = 6;

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < _minLength) {
      return PasswordValidationError.tooShort;
    }
    return null;
  }
}

extension Explanation on PasswordValidationError {
  String? get errorMessage {
    switch (this) {
      case PasswordValidationError.tooShort:
        return "Password must be at least 6 characters long";
      case PasswordValidationError.empty:
        return "Password cannot be empty";
      default:
        return null;
    }
  }
}

import 'package:formz/formz.dart';

enum EmailValidationError {
  invalid,
  empty;
}

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

extension Explanation on EmailValidationError {
  String? get errorMessage {
    switch (this) {
      case EmailValidationError.invalid:
        return "This is not a valid email address";
      case EmailValidationError.empty:
        return "The email address cannot be empty";
      default:
        return null;
    }
  }
}

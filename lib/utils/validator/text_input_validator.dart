import 'package:formz/formz.dart';

enum TextInputValidationError {
  empty;
}

class TextInput extends FormzInput<String, TextInputValidationError> {
  const TextInput.pure() : super.pure('');
  const TextInput.dirty([super.value = '']) : super.dirty();

  @override
  TextInputValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return TextInputValidationError.empty;
    }
    return null;
  }
}

extension Explanation on TextInputValidationError {
  String? get errorMessage {
    switch (this) {
      case TextInputValidationError.empty:
        return "This field cannot be empty";
      default:
        return null;
    }
  }
}

import 'package:flutter/services.dart';

class VietnameseNameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regExp = RegExp(
      r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$',
    );

    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class EmailInputFormatter extends TextInputFormatter {
  final RegExp _emailRegExp = RegExp(r'[a-zA-Z0-9@._-]*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow characters that match the email regex
    if (_emailRegExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

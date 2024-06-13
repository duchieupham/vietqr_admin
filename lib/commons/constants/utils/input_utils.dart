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

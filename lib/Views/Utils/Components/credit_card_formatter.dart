import 'package:flutter/services.dart';

class CreditCardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-digit characters

    if (text.length > 0) {
      text = text.replaceAll(' ', ''); // Remove existing spaces
      var newText = '';

      for (int i = 0; i < text.length; i++) {
        if (i % 4 == 0 && i != 0) {
          newText += ' '; // Add space after every 4 characters
        }
        newText += text[i];
      }

      return TextEditingValue(
        text: newText,
        selection: newValue.selection,
      );
    } else {
      return newValue;
    }
  }
}
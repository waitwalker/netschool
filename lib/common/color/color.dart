
import 'package:flutter/material.dart';
class ETTColor {
  static Color c1_color = ColorConvert.convert("4aacee");

  static Color g4_color = ColorConvert.convert("cccccc");

  static Color background_color = ColorConvert.convert("F2F7FF");

  static Color student_select_identity_color = Color.fromRGBO(239, 124, 106, 1.0);
  static Color teacher_select_identity_color = Color.fromRGBO(114, 176, 249, 1.0);
}

class ColorConvert {

  static Color convert(String hexCode){
    if (hexCode.startsWith('#')) {
      hexCode = hexCode.substring(1);
    }
    if (hexCode.length > 6) {
      List<String> hexDigits = hexCode.split('');
      int r = int.parse(hexDigits.sublist(0, 2).join(), radix: 16);
      int g = int.parse(hexDigits.sublist(2, 4).join(), radix: 16);
      int b = int.parse(hexDigits.sublist(4, 6).join(), radix: 16);
      double opacity = (int.parse(hexDigits.sublist(6).join(), radix: 16) / 100);
      return Color.fromRGBO(r, g, b, opacity);
    } else {

      List<String> hexDigits = hexCode.split('');
      int r = int.parse(hexDigits.sublist(0, 2).join(), radix: 16);
      int g = int.parse(hexDigits.sublist(2, 4).join(), radix: 16);
      int b = int.parse(hexDigits.sublist(4).join(), radix: 16);
      return Color.fromRGBO(r, g, b, 1);
    }
  }
}
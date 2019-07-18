import 'package:flutter/material.dart';

enum STRICON {
  EMAIL,
  OUTBOUND_EMAIL,
  E_COMMERCE,
  CALL_CENTER,
  PORTAL,
  PHONE,
  FORUM,
  TWITTER,
  FACEBOOK,
  CHAT,
  MOBIHELP,
  FEEDBACKWIDGET
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

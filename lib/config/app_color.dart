import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColor {
  static Color selectColor(Color colorForLight, Color colorForDark) {
    return Get.isDarkMode ? colorForDark : colorForLight;
  }

  static MaterialColor primaryColor = const MaterialColor(
    0xFF31AFB4,
    <int, Color>{
      50: Color(0xFF31AFB4),
      100: Color(0xFF31AFB4),
      200: Color(0xFF31AFB4),
      300: Color(0xFF31AFB4),
      350: Color(0xFF31AFB4),
      400: Color(0xFF31AFB4),
      500: Color(0xFF31AFB4),
      600: Color(0xFF31AFB4),
      700: Color(0xFF31AFB4),
      800: Color(0xFF31AFB4),
      850: Color(0xFF31AFB4),
      900: Color(0xFF31AFB4),
    },
  );
  static MaterialColor accentColor = const MaterialColor(
    0xFFC6E8EA,
    <int, Color>{
      50: Color(0xFFC6E8EA),
      100: Color(0xFFC6E8EA),
      200: Color(0xFFC6E8EA),
      300: Color(0xFFC6E8EA),
      350: Color(0xFFC6E8EA),
      400: Color(0xFFC6E8EA),
      500: Color(0xFFC6E8EA),
      600: Color(0xFFC6E8EA),
      700: Color(0xFFC6E8EA),
      800: Color(0xFFC6E8EA),
      850: Color(0xFFC6E8EA),
      900: Color(0xFFC6E8EA),
    },
  );
  static MaterialColor tertiaryColor = const MaterialColor(
    0xFF1E3354,
    <int, Color>{
      50: Color(0xFF1E3354),
      100: Color(0xFF1E3354),
      200: Color(0xFF1E3354),
      300: Color(0xFF1E3354),
      350: Color(0xFF1E3354),
      400: Color(0xFF1E3354),
      500: Color(0xFF1E3354),
      600: Color(0xFF1E3354),
      700: Color(0xFF1E3354),
      800: Color(0xFF1E3354),
      850: Color(0xFF1E3354),
      900: Color(0xFF1E3354),
    },
  );
  static const Color green = Color(0xFF48EE6C);
  static const Color blue = Color.fromRGBO(156, 180, 255, 1.0);
  static const Color blue2 = Color.fromRGBO(0, 60, 255, 1.0);
  static const Color gray = Color.fromRGBO(30, 30, 30, 1);
  static const Color red = Color(0xFFFF3D3D);
  static const Color gray2 = Color.fromRGBO(149, 149, 149, 1.0);
  static const Color grayLight = Color.fromRGBO(236, 236, 236, 1);
  static const Color grayDark = Color(0xFF181818);
  static const Color grayLightTransparent = Color.fromRGBO(224, 224, 224, 0.7);
  static const Color chatReceived = Color(0xFFFFEFEE);
  static const Color colorIcon = Color(0xFF666666);
  static const Color colorWhiteTransparent = Color(0xFFfdfafa);

  static const Color textFieldBorderLight = Color(0xFF828282);
  static const Color textFieldBorderDark = Color(0xFFA4A4A4);

  static const Color textFieldLight = Color(0xFF828282);
  static const Color textFieldDark = Color(0xFFA4A4A4);
}

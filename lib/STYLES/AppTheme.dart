import 'package:flutter/material.dart';

const Color appTransparent = Color(0x00FFFFFF);
const Color pink = Color(0xFFEF476F);
const Color lightPink = Color(0xFFEAA9B8);
const Color yellow = Color(0xFFFFD166);
const Color green = Color(0xFF06D6A0);
const Color lightGreen = Color(0xFF77DEC3);
const Color lightWhiteGreen = Color(0xFFE3F1ED);
const Color lightBlue = Color(0xFF118AB2);
const Color darkBlue = Color(0xFF073B4C);

final ThemeData appThemeData = ThemeData(
  primaryColor: green,
  colorScheme: ColorScheme.fromSwatch().copyWith(primary: green, secondary: pink),
  // Define other theme attributes as needed
);

final TextStyle titleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

final TextStyle chatSenderTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

final TextStyle chatTimeTextStyle = TextStyle(
  color: Colors.grey,
);

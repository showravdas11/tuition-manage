import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // fontFamily: GoogleFonts.lato().fontFamily,
        canvasColor: canvousColor,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            // backgroundColor: darkBluishColor,
            ),
        useMaterial3: true,
      );

  // colors

  static Color canvousColor = Color(0xFFFBE8B5);
  static Color canvousColorPrimary = Color(0xFFFAFBFD);
  static Color buttonColor = Color(0xFF1E1E1E);
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'letter_spacing.dart';

class AppThemeData {
  final BorderRadius borderRadius = BorderRadius.circular(8);

  final Color colorYellow = const Color(0xffffff00);
  final Color colorPrimary = const Color(0xffabcdef);

  ThemeData get materialTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(0xFF33333D),
        elevation: 0,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        elevation: 0,
      ),
      tabBarTheme: null,
      errorColor: const Color(0xFFB87171),
      scaffoldBackgroundColor: const Color(0xFF33333D),
      buttonTheme: const ButtonThemeData(buttonColor: Colors.blue),
      outlinedButtonTheme: outlineButtonThemeData,
      textButtonTheme: textButtonThemeData,
      backgroundColor: const Color(0xFF33333D),
      primaryColor: const Color(0xFF1C839E),
      secondaryHeaderColor: Colors.white,
      primaryColorDark: Colors.black,
      primaryColorLight: const Color(0xFF9970A9),
      focusColor: const Color(0xCCFFFFFF),
      textTheme: _buildTextTheme(base.textTheme),
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: Colors.lightBlue[50]), // app header text
      ),
      inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Colors.lightBlue,
            fontWeight: FontWeight.w500,
          ),
          isDense: false,
          contentPadding: EdgeInsets.all(5),
          filled: false,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF935D5D), width: 1.0),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF935D5D), width: 1.0),
          ),
          fillColor: Color(0xFFE0E2E2),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purpleAccent, width: 1.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 1.0),
          )),
      visualDensity: VisualDensity.standard,
      cardColor: Colors.black12,
      dialogBackgroundColor: Colors.white,
      shadowColor: Colors.grey,
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base
        .apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        )
        .copyWith(
          bodyText1: GoogleFonts.sourceSansPro(
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.normal,
              letterSpacing: letterSpacingOrNone(0.5),
              color: Colors.white),
          bodyText2: GoogleFonts.sourceSansPro(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(0.5),
            color: Colors.lightGreen,
          ),
          button: GoogleFonts.sourceSansPro(
            fontWeight: FontWeight.w700,
            letterSpacing: letterSpacingOrNone(2.8),
            color: Colors.lightBlue[200],
          ),
          caption: GoogleFonts.sourceSansPro(
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.normal,
              letterSpacing: letterSpacingOrNone(0.5),
              color: Colors.white),
          headline1:
              GoogleFonts.sourceSansPro(color: const Color(0xFF1C839E), fontSize: 40, fontWeight: FontWeight.w100),
          headline3: GoogleFonts.sourceSansPro(fontSize: 24, fontWeight: FontWeight.w400),
          headline4: GoogleFonts.sourceSansPro(color: Colors.lightGreenAccent),
          headline5: GoogleFonts.sourceSansPro(
              fontSize: 40, fontWeight: FontWeight.w600, letterSpacing: letterSpacingOrNone(1.4), color: Colors.white),
          subtitle1: const TextStyle(color: Colors.lightGreenAccent), // input text
          headline6: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        );
  }

  OutlinedButtonThemeData get outlineButtonThemeData {
    return OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    ).copyWith(side: MaterialStateProperty.resolveWith<BorderSide?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(
            color: Colors.yellow,
            width: 1,
          );
        } else {
          return const BorderSide(
            color: Color(0xFF1C839E),
            width: 1,
          );
        }
      },
    )));
  }

  TextButtonThemeData get textButtonThemeData {
    return TextButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    ).copyWith(side: MaterialStateProperty.resolveWith<BorderSide?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(
            color: Colors.yellow,
            width: 1,
          );
        } else {
          return const BorderSide(
            color: Color(0xFF1C839E),
            width: 1,
          );
        }
      },
    )));
  }
}

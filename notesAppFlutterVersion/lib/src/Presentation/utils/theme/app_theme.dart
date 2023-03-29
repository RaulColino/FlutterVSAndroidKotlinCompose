import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {

  static const kTextColor = Colors.black54;

  static ThemeData theme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Muli",
      appBarTheme: _appBarTheme(),
      textTheme: _textTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kTextColor),
      gapPadding: 10,
    );
    return InputDecorationTheme(
      // If  you are using latest version of flutter then lable text and hint text shown like this
      // if you r using flutter less then 1.20.* then maybe this is not working properly
      // if we are define our floatingLabelBehavior in our theme then it's not applayed
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
    );
  }

  static TextTheme _textTheme() {
    return const TextTheme(
      bodyText1: TextStyle(color: kTextColor),
      bodyText2: TextStyle(color: kTextColor),
    );
  }

  static AppBarTheme _appBarTheme() {
    return AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black), 
      
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      ).bodyText2, 
      
      titleTextStyle: const TextTheme(
        headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
      ).headline6, systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
}

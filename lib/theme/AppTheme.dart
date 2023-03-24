import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
      //
      //* AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
      //
      //* Scaffold
      scaffoldBackgroundColor: Colors.white,
      //
      //* Text
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
      ),
      //
      //* Icons
      iconTheme: IconThemeData(color: Colors.black));
}

import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28.0),
      ),
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
    ),
  ),
  textTheme: const TextTheme(
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 18),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    labelSmall: TextStyle(fontSize: 14),
    labelMedium: TextStyle(fontSize: 16),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

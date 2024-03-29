// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:shop_app/models/dark_theme_preferences.dart';

class DarkThemeProvider with ChangeNotifier
{
  DarkThemePreferences darkThemePreferences = DarkThemePreferences();

  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;

  set darkTheme (bool value)
  {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}
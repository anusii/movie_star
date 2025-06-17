/// Service for managing application theme preferences.
///
// Time-stamp: <Thursday 2025-01-16 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.

library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing theme preferences and persistence.
class ThemeService {
  /// Shared preferences instance for storing theme data.
  final SharedPreferences _prefs;
  
  /// Key for storing theme mode in shared preferences.
  static const String _themeModeKey = 'theme_mode';
  
  /// Creates a new [ThemeService] instance.
  ThemeService(this._prefs);
  
  /// Gets the current theme mode from shared preferences.
  /// Returns [ThemeMode.dark] as default if no preference is set.
  ThemeMode getThemeMode() {
    final String? themeModeString = _prefs.getString(_themeModeKey);
    if (themeModeString == null) {
      return ThemeMode.dark; // Default to dark mode for movie app
    }
    
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }
  
  /// Sets the theme mode and saves it to shared preferences.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    String themeModeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }
    
    await _prefs.setString(_themeModeKey, themeModeString);
  }
  
  /// Toggles between light and dark theme modes.
  /// Returns the new theme mode.
  Future<ThemeMode> toggleTheme() async {
    final currentMode = getThemeMode();
    final newMode = currentMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    await setThemeMode(newMode);
    return newMode;
  }
} 
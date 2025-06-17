/// Service for managing application theme preferences.
///
// Time-stamp: <Thursday 2025-04-10 11:47:48 +1000 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Ashley Tang

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
      // Default to dark mode for movie app.

      return ThemeMode.dark;
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
    final newMode =
        currentMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await setThemeMode(newMode);
    return newMode;
  }
}

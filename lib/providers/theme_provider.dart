/// Riverpod providers for theme management.
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:moviestar/services/theme_service.dart';

/// Provider for SharedPreferences instance.

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences provider not initialized');
});

/// Provider for the ThemeService.

final themeServiceProvider = Provider<ThemeService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeService(prefs);
});

/// Provider for the current theme mode.

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeModeNotifier(themeService);
});

/// State notifier for managing theme mode changes.

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  /// Theme service for persistence.

  final ThemeService _themeService;

  /// Creates a new [ThemeModeNotifier] instance.

  ThemeModeNotifier(this._themeService) : super(_themeService.getThemeMode());

  /// Toggles between light and dark theme modes.

  Future<void> toggleTheme() async {
    final newThemeMode = await _themeService.toggleTheme();
    state = newThemeMode;
  }

  /// Sets a specific theme mode.

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _themeService.setThemeMode(themeMode);
    state = themeMode;
  }

  /// Returns true if the current theme is dark mode.

  bool get isDarkMode => state == ThemeMode.dark;

  /// Returns true if the current theme is light mode.

  bool get isLightMode => state == ThemeMode.light;

  /// Returns true if the current theme follows system settings.

  bool get isSystemMode => state == ThemeMode.system;
}

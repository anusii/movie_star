/// Database provider for the Movie Star application.
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

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moviestar/database/app_database.dart';

/// Provider for the main application database.
///
/// This creates a singleton instance of AppDatabase that can be accessed
/// throughout the application. The database will be automatically closed
/// when the provider is disposed.

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  // Ensure the database is closed when the provider is disposed.

  ref.onDispose(() {
    database.close();
  });

  return database;
});

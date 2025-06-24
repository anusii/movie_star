/// Database provider for the Movie Star application.
///
/// This provider manages the AppDatabase instance and provides access
/// to the database throughout the application using Riverpod.
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
/// Licensed under the GNU General Public License, Version 3 (the "License").

library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:moviestar/database/app_database.dart';

/// Provider for the main application database
///
/// This creates a singleton instance of AppDatabase that can be accessed
/// throughout the application. The database will be automatically closed
/// when the provider is disposed.
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  // Ensure the database is closed when the provider is disposed
  ref.onDispose(() {
    database.close();
  });

  return database;
});

/// Provider for managing movie cache repository access throughout the app.
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

import 'package:flutter/foundation.dart';

import 'package:moviestar/database/app_database.dart';
import 'package:moviestar/database/movie_cache_repository.dart';

/// Provider for movie cache repository.

class MovieCacheProvider extends ChangeNotifier {
  /// The movie cache repository instance.

  late final MovieCacheRepository _repository;

  /// Database instance.

  late final AppDatabase _database;

  /// Whether the provider is initialised.

  bool _isInitialized = false;

  /// Getter for the repository.

  MovieCacheRepository get repository {
    if (!_isInitialized) {
      throw StateError(
        'MovieCacheProvider not initialized. Call initialize() first.',
      );
    }
    return _repository;
  }

  /// Whether the provider is initialised.

  bool get isInitialized => _isInitialized;

  /// Initializes the provider with database connection.

  Future<void> initialize() async {
    if (_isInitialized) return;

    _database = AppDatabase();
    _repository = MovieCacheRepository(_database);
    _isInitialized = true;

    notifyListeners();
  }

  /// Updates cache configuration and notifies listeners.

  void updateCacheConfig(Map<CacheCategory, Duration> ttls) {
    _repository.updateCacheConfig(ttls);
    notifyListeners();
  }

  /// Resets cache configuration to defaults and notifies listeners.

  void resetCacheConfig() {
    _repository.resetCacheConfig();
    notifyListeners();
  }

  /// Invalidates all cache and notifies listeners.

  Future<void> clearAllCache() async {
    await _repository.invalidateAllCache();
    notifyListeners();
  }

  /// Invalidates specific category cache and notifies listeners.

  Future<void> clearCategoryCache(CacheCategory category) async {
    await _repository.invalidateCache(category);
    notifyListeners();
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _database.close();
    }
    super.dispose();
  }
}

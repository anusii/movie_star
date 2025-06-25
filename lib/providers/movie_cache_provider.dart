/// Provider for managing movie cache repository access throughout the app.
///
/// This provider makes the MovieCacheRepository available to widgets and services
/// using Flutter's provider pattern for dependency injection.
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
/// Licensed under the GNU General Public License, Version 3 (the "License").

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
  
  /// Whether the provider is initialized.
  bool _isInitialized = false;
  
  /// Getter for the repository.
  MovieCacheRepository get repository {
    if (!_isInitialized) {
      throw StateError('MovieCacheProvider not initialized. Call initialize() first.');
    }
    return _repository;
  }
  
  /// Whether the provider is initialized.
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
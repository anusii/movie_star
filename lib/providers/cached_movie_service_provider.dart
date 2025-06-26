/// Provider for the cached movie service in the Movie Star application.
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

import 'package:moviestar/database/movie_cache_repository.dart';
import 'package:moviestar/models/movie.dart';
import 'package:moviestar/providers/database_provider.dart';
import 'package:moviestar/services/api_key_service.dart';
import 'package:moviestar/services/cached_movie_service.dart';
import 'package:moviestar/services/movie_service.dart';

/// Provider for the API key service.

final apiKeyServiceProvider = Provider<ApiKeyService>((ref) {
  return ApiKeyService();
});

/// Provider for the movie service.

final movieServiceProvider = Provider<MovieService>((ref) {
  final apiKeyService = ref.watch(apiKeyServiceProvider);
  return MovieService(apiKeyService);
});

/// Provider for the movie cache repository.

final movieCacheRepositoryProvider = Provider<MovieCacheRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return MovieCacheRepository(database);
});

/// Provider for the cached movie service.

final cachedMovieServiceProvider = Provider<CachedMovieService>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  final cacheRepository = ref.watch(movieCacheRepositoryProvider);

  final cachedService = CachedMovieService(
    movieService,
    cacheRepository,
    cachingEnabled: true,
    cacheOnlyMode: false,
  );

  // Ensure proper disposal.

  ref.onDispose(() {
    cachedService.dispose();
  });

  return cachedService;
});

/// Provider for cache-only mode state.

final cacheOnlyModeProvider = StateProvider<bool>((ref) => false);

/// Provider for caching enabled state.

final cachingEnabledProvider = StateProvider<bool>((ref) => true);

/// Provider for configured cached movie service (with settings).

final configuredCachedMovieServiceProvider = Provider<CachedMovieService>((
  ref,
) {
  final movieService = ref.watch(movieServiceProvider);
  final cacheRepository = ref.watch(movieCacheRepositoryProvider);
  final cachingEnabled = ref.watch(cachingEnabledProvider);
  final cacheOnlyMode = ref.watch(cacheOnlyModeProvider);

  final cachedService = CachedMovieService(
    movieService,
    cacheRepository,
    cachingEnabled: cachingEnabled,
    cacheOnlyMode: cacheOnlyMode,
  );

  // Ensure proper disposal.

  ref.onDispose(() {
    cachedService.dispose();
  });

  return cachedService;
});

/// Provider for popular movies with caching.

final popularMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  return await cachedService.getPopularMovies();
});

/// Provider for now playing movies with caching.

final nowPlayingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  return await cachedService.getNowPlayingMovies();
});

/// Provider for top rated movies with caching.

final topRatedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  return await cachedService.getTopRatedMovies();
});

/// Provider for upcoming movies with caching.

final upcomingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  return await cachedService.getUpcomingMovies();
});

/// Provider for cache statistics.

final cacheStatsProvider = FutureProvider<Map<CacheCategory, CacheStats>>((
  ref,
) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  return await cachedService.getCacheStats();
});

/// Provider for force refresh functionality.

final forceRefreshProvider = FutureProvider.family<List<Movie>, CacheCategory>((
  ref,
  category,
) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  return await cachedService.forceRefresh(category);
});

/// Provider for clearing cache functionality.

final clearCacheProvider = FutureProvider.family<void, CacheCategory>((
  ref,
  category,
) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  await cachedService.clearCache(category);
});

/// Provider for clearing all cache functionality.

final clearAllCacheProvider = FutureProvider<void>((ref) async {
  final cachedService = ref.watch(configuredCachedMovieServiceProvider);
  await cachedService.clearAllCache();
});

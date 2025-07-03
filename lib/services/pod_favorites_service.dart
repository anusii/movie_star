/// POD-based service for managing favorite movies using Solid POD storage.
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

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solidpod/solidpod.dart';

import 'package:moviestar/models/movie.dart';
import 'package:moviestar/services/favorites_service.dart';
import 'package:moviestar/utils/is_logged_in.dart';
import 'package:moviestar/utils/turtle_serializer.dart';

/// A POD-based service class that manages the user's movie lists in Solid POD.

class PodFavoritesService extends ChangeNotifier {
  /// File names for storing data in POD - using different paths for read vs write operations.

  static const String _toWatchFileName = 'user_lists/to_watch.ttl';
  static const String _watchedFileName = 'user_lists/watched.ttl';
  static const String _ratingsFileName = 'ratings/ratings.ttl';
  static const String _commentsFileName = 'user_lists/comments.ttl';

  // Full paths for reading operations (where files are actually stored).

  static const String _toWatchFileNameRead =
      'moviestar/data/user_lists/to_watch.ttl';
  static const String _watchedFileNameRead =
      'moviestar/data/user_lists/watched.ttl';
  static const String _ratingsFileNameRead =
      'moviestar/data/ratings/ratings.ttl';
  static const String _commentsFileNameRead =
      'moviestar/data/user_lists/comments.ttl';

  /// Widget context for POD operations.

  final BuildContext _context;

  /// Widget for returning after operations.

  final Widget _child;

  /// SharedPreferences for fallback storage.

  final SharedPreferences _prefs;

  /// Fallback favorites service for compatibility.

  final FavoritesService _fallbackService;

  /// Track which movies have files to avoid unnecessary reads.

  final Set<int> _moviesWithFiles = {};

  /// Cache for movie data to avoid frequent POD reads.

  List<Movie>? _cachedToWatch;
  List<Movie>? _cachedWatched;
  Map<String, double>? _cachedRatings;
  Map<String, String>? _cachedComments;

  /// Track if we're currently syncing with POD.

  bool _isSyncing = false;

  /// Stream controller for to-watch movies.

  final _toWatchController = BehaviorSubject<List<Movie>>();

  /// Stream controller for watched movies.

  final _watchedController = BehaviorSubject<List<Movie>>();

  /// Stream of to-watch movies.

  Stream<List<Movie>> get toWatchMovies => _toWatchController.stream;

  /// Stream of watched movies.

  Stream<List<Movie>> get watchedMovies => _watchedController.stream;

  /// Track pending movie file updates to batch them.

  final Map<int, Timer> _pendingMovieUpdates = {};

  /// Creates a new [PodFavoritesService] instance.

  PodFavoritesService(this._prefs, this._context, this._child)
      : _fallbackService = FavoritesService(_prefs) {
    _initializePodData();
  }

  /// Initialize POD data by loading from POD if available.

  Future<void> _initializePodData() async {
    try {
      // Check if user is logged into POD first.

      final isPodReady = await isPodAvailable();
      if (isPodReady) {
        // Try to load from POD, but don't fail if folders aren't ready yet.

        await _loadFromPod();
      } else {
        // Initialize with empty data for new POD storage.

        _cachedToWatch = [];
        _cachedWatched = [];
        _cachedRatings = {};
        _cachedComments = {};
        _toWatchController.add(_cachedToWatch!);
        _watchedController.add(_cachedWatched!);
      }
    } catch (e) {
      debugPrint('Failed to initialize POD data: $e');
      // Initialize with empty data.

      _cachedToWatch = [];
      _cachedWatched = [];
      _cachedRatings = {};
      _cachedComments = {};
      _toWatchController.add(_cachedToWatch!);
      _watchedController.add(_cachedWatched!);
    }
  }

  /// Loads data from POD and caches it locally.

  Future<void> _loadFromPod() async {
    _isSyncing = true;

    try {
      // Initialize with empty data first.

      _cachedToWatch = [];
      _cachedWatched = [];
      _cachedRatings = {};
      _cachedComments = {};

      // Try to load each file individually without key validation to avoid encryption conflicts

      await _loadFileFromPodWithoutKey(_toWatchFileNameRead, (content) {
        if (content is String) {
          _cachedToWatch = TurtleSerializer.moviesFromTurtle(content);
        }
      });

      await _loadFileFromPodWithoutKey(_watchedFileNameRead, (content) {
        if (content is String) {
          _cachedWatched = TurtleSerializer.moviesFromTurtle(content);
        }
      });

      await _loadFileFromPodWithoutKey(_ratingsFileNameRead, (content) {
        if (content is String) {
          _cachedRatings = TurtleSerializer.ratingsFromTurtle(content);
        }
      });

      // Skip loading old comments file - we use individual movie files now.
      // The old comments.ttl file has encryption key conflicts.

      _cachedComments = {};

      // Update streams with POD data.

      _toWatchController.add(_cachedToWatch!);
      _watchedController.add(_cachedWatched!);
    } catch (e) {
      debugPrint('Error loading from POD: $e');
      // Initialize with empty data if POD fails.

      _cachedToWatch = [];
      _cachedWatched = [];
      _cachedRatings = {};
      _cachedComments = {};
    } finally {
      _isSyncing = false;
    }
  }

  /// Helper method to load a single file from POD without key validation.

  Future<void> _loadFileFromPodWithoutKey(
    String fileName,
    Function(dynamic) onSuccess,
  ) async {
    try {
      final loggedIn = await isLoggedIn();
      if (!loggedIn) {
        return;
      }

      if (!_context.mounted) return;

      // Skip getKeyFromUserIfRequired to avoid encryption key conflicts.

      final content = await readPod(fileName, _context, _child);
      onSuccess(content);
      return;
    } catch (e) {
      // Handle specific encryption key conflicts.

      if (e.toString().contains('Duplicated encryption key')) {
        // Skip this file - we'll use movie files instead.

        return;
      }

      // Suppress "does not exist" errors - these are expected for new files.

      if (e.toString().contains('does not exist')) {
        return;
      }

      // For other errors, we can try to continue without this file.

      debugPrint('Error loading file $fileName: $e');
      return;
    }
  }

  /// Saves to-watch list to POD.

  Future<void> _saveToWatchToPod(List<Movie> movies) async {
    if (_isSyncing) return;

    try {
      final loggedIn = await isLoggedIn();
      if (!loggedIn) {
        final encoded = jsonEncode(movies.map((m) => m.toJson()).toList());
        await _prefs.setString('to_watch', encoded);
        return;
      }

      final ttlContent = TurtleSerializer.moviesToTurtleWithJson(
        movies,
        'toWatchList',
      );

      if (!_context.mounted) return;

      // Skip getKeyFromUserIfRequired to avoid encryption key conflicts.

      final result = await writePod(
        _toWatchFileName,
        ttlContent,
        _context,
        _child,
      );

      if (result == SolidFunctionCallStatus.success) {
        _cachedToWatch = List.from(movies);
        await Future.delayed(const Duration(milliseconds: 500));
      } else {
        debugPrint('WritePod failed with status: $result');
        throw Exception('WritePod failed with status: $result');
      }
    } catch (e) {
      debugPrint('Failed to save to-watch list to POD: $e');
      final encoded = jsonEncode(movies.map((m) => m.toJson()).toList());
      await _prefs.setString('to_watch', encoded);
    }
  }

  /// Saves watched list to POD.

  Future<void> _saveWatchedToPod(List<Movie> movies) async {
    if (_isSyncing) return;

    try {
      final ttlContent = TurtleSerializer.moviesToTurtleWithJson(
        movies,
        'watchedList',
      );
      await writePod(_watchedFileName, ttlContent, _context, _child);
      _cachedWatched = List.from(movies);
    } catch (e) {
      debugPrint('Failed to save watched list to POD: $e');

      // Fallback to SharedPreferences.

      final encoded = jsonEncode(movies.map((m) => m.toJson()).toList());
      await _prefs.setString('watched', encoded);
    }
  }

  /// Saves ratings to POD.

  Future<void> _saveRatingsToPod(Map<String, double> ratings) async {
    if (_isSyncing) return;

    try {
      final ttlContent = TurtleSerializer.ratingsToTurtleWithJson(ratings);
      await writePod(_ratingsFileName, ttlContent, _context, _child,
          encrypted: false);
      _cachedRatings = Map.from(ratings);
    } catch (e) {
      // Don't log - this is background save for compatibility
      // debugPrint('Failed to save ratings to POD: $e');
    }
  }

  /// Saves comments to POD.

  Future<void> _saveCommentsToPod(Map<String, String> comments) async {
    if (_isSyncing) return;

    try {
      final ttlContent = TurtleSerializer.commentsToTurtleWithJson(comments);
      await writePod(_commentsFileName, ttlContent, _context, _child,
          encrypted: false);
      _cachedComments = Map.from(comments);
    } catch (e) {
      // Don't log - this is background save for compatibility
      // debugPrint('Failed to save comments to POD: $e');
    }
  }

  /// Retrieves the list of to-watch movies from POD cache.

  Future<List<Movie>> getToWatch() async {
    if (_cachedToWatch != null) {
      return List.from(_cachedToWatch!);
    }

    // Fallback to SharedPreferences if cache is empty.

    return _fallbackService.getToWatch();
  }

  /// Retrieves the list of watched movies from POD cache.

  Future<List<Movie>> getWatched() async {
    if (_cachedWatched != null) {
      return List.from(_cachedWatched!);
    }

    // Fallback to SharedPreferences if cache is empty.

    return _fallbackService.getWatched();
  }

  /// Adds a movie to the to-watch list and saves to POD.

  Future<void> addToWatch(Movie movie) async {
    final toWatch = await getToWatch();

    if (!toWatch.any((m) => m.id == movie.id)) {
      toWatch.add(movie);
      await _saveToWatchToPod(toWatch);
      _toWatchController.add(toWatch);
    }
  }

  /// Adds a movie to the watched list and saves to POD.

  Future<void> addToWatched(Movie movie) async {
    final watched = await getWatched();
    if (!watched.any((m) => m.id == movie.id)) {
      watched.add(movie);
      await _saveWatchedToPod(watched);
      _watchedController.add(watched);
    }
  }

  /// Removes a movie from the to-watch list and saves to POD.

  Future<void> removeFromToWatch(Movie movie) async {
    final toWatch = await getToWatch();
    toWatch.removeWhere((m) => m.id == movie.id);
    await _saveToWatchToPod(toWatch);
    _toWatchController.add(toWatch);
  }

  /// Removes a movie from the watched list and saves to POD.

  Future<void> removeFromWatched(Movie movie) async {
    final watched = await getWatched();
    watched.removeWhere((m) => m.id == movie.id);
    await _saveWatchedToPod(watched);
    _watchedController.add(watched);
  }

  /// Checks if a movie is in the to-watch list.

  Future<bool> isInToWatch(Movie movie) async {
    final toWatch = await getToWatch();
    return toWatch.any((m) => m.id == movie.id);
  }

  /// Checks if a movie is in the watched list.

  Future<bool> isInWatched(Movie movie) async {
    final watched = await getWatched();
    return watched.any((m) => m.id == movie.id);
  }

  /// Gets the personal rating for a movie from POD.

  Future<double?> getPersonalRating(Movie movie) async {
    // First check cache.

    if (_cachedRatings != null &&
        _cachedRatings!.containsKey(movie.id.toString())) {
      return _cachedRatings![movie.id.toString()];
    }

    // Try to read file - on first read after app restart, _moviesWithFiles will be empty.
    // But we should still try to read existing files.

    final movieData = await _readMovieFile(movie);
    if (movieData != null && movieData['rating'] != null) {
      final rating = movieData['rating'] as double?;
      if (rating != null) {
        // Cache the result and mark as having a file.

        _cachedRatings ??= {};
        _cachedRatings![movie.id.toString()] = rating;
        _moviesWithFiles.add(movie.id);
        return rating;
      }
    }

    // No rating found - don't cache null values, just return null.

    return null;
  }

  /// Sets the user's personal rating for a movie and saves to POD.

  Future<void> setPersonalRating(Movie movie, double rating) async {
    try {
      // IMMEDIATELY update cache and mark as having file to prevent any reads.

      _cachedRatings ??= {};
      _cachedRatings![movie.id.toString()] = rating;
      _moviesWithFiles.add(movie.id);

      // Create/update the single movie file with the new rating - this is the primary storage now.

      await _createOrUpdateMovieFile(movie, rating: rating);

      // Skip backward compatibility saves to avoid encryption warnings.
      // The movie files are now the primary storage.
    } catch (e) {
      debugPrint('Failed to save rating: $e');
      // Let the UI handle error feedback.
    }
  }

  /// Removes the user's personal rating for a movie from POD.

  Future<void> removePersonalRating(Movie movie) async {
    // Update the cache first to remove the rating.

    final ratings = _cachedRatings ?? {};
    ratings.remove(movie.id.toString());
    _cachedRatings = ratings;

    // Update the single movie file (primary storage) - will remove rating but keep comment if exists.

    await _createOrUpdateMovieFile(movie);

    // Skip backward compatibility saves to avoid encryption warnings.
  }

  /// Gets the personal comments for a movie from POD.

  Future<String?> getMovieComments(Movie movie) async {
    // First check cache.

    if (_cachedComments != null &&
        _cachedComments!.containsKey(movie.id.toString())) {
      final cached = _cachedComments![movie.id.toString()];
      return cached?.isNotEmpty == true ? cached : null;
    }

    // Try to read file - on first read after app restart, _moviesWithFiles will be empty.
    // But we should still try to read existing files.

    final movieData = await _readMovieFile(movie);
    if (movieData != null && movieData['comment'] != null) {
      final comment = movieData['comment'] as String?;
      if (comment != null && comment.isNotEmpty) {
        // Cache the result and mark as having a file.

        _cachedComments ??= {};
        _cachedComments![movie.id.toString()] = comment;
        _moviesWithFiles.add(movie.id);
        return comment;
      }
    }

    // No comment found - don't cache null values, just return null
    return null;
  }

  /// Sets the personal comments for a movie and saves to POD.

  Future<void> setMovieComments(Movie movie, String comments) async {
    try {
      // Immediately update cache and mark as having file to prevent any reads.

      _cachedComments ??= {};
      _cachedComments![movie.id.toString()] = comments;
      _moviesWithFiles.add(movie.id);

      // Create/update the single movie file with the new comment - this is the primary storage now.

      await _createOrUpdateMovieFile(movie, comment: comments);

      // Skip backward compatibility saves to avoid encryption warnings.
      // The movie files are now the primary storage.

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to save comments: $e');
      // Let the UI handle error feedback.
    }
  }

  /// Removes the personal comments for a movie from POD.

  Future<void> removeMovieComments(Movie movie) async {
    // Update the cache first to remove the comment.

    final comments = _cachedComments ?? {};
    comments.remove(movie.id.toString());
    _cachedComments = comments;

    // Update the single movie file (primary storage) - will remove comment but keep rating if exists.

    await _createOrUpdateMovieFile(movie);

    // Skip backward compatibility saves to avoid encryption warnings.

    notifyListeners();
  }

  // NEW SINGLE-FILE MOVIE METHODS

  /// Creates or updates a single movie file containing movie data and user's personal rating/comment.
  /// This is called whenever a user rates or comments on a movie.

  Future<void> _createOrUpdateMovieFile(Movie movie,
      {double? rating, String? comment}) async {
    if (_isSyncing) return;

    // Cancel any pending update for this movie.

    _pendingMovieUpdates[movie.id]?.cancel();

    // Schedule a new update with a 500ms delay to batch rapid changes.

    _pendingMovieUpdates[movie.id] =
        Timer(const Duration(milliseconds: 500), () async {
      await _performMovieFileUpdate(movie, rating: rating, comment: comment);
      _pendingMovieUpdates.remove(movie.id);
    });
  }

  /// Actually performs the movie file update after debouncing.

  Future<void> _performMovieFileUpdate(Movie movie,
      {double? rating, String? comment}) async {
    try {
      final loggedIn = await isLoggedIn();
      if (!loggedIn) {
        return;
      }

      // Use provided parameters first, then fallback to cache (never read from file).

      final currentRating = rating ?? _cachedRatings?[movie.id.toString()];
      final currentComment = comment ?? _cachedComments?[movie.id.toString()];

      // Only proceed if we have actual data to save.

      if (currentRating == null &&
          (currentComment == null || currentComment.isEmpty)) {
        return;
      }

      final movieFileName = 'movies/movie-${movie.id}.ttl';

      final ttlContent = TurtleSerializer.movieWithUserDataToTurtle(
        movie,
        currentRating,
        currentComment,
      );

      // Write to POD without encryption to prevent multiple encryption keys.

      if (!_context.mounted) return;
      final result = await writePod(
        movieFileName,
        ttlContent,
        _context,
        _child,
        encrypted: false,
      );

      if (result == SolidFunctionCallStatus.success) {
        // Success - file saved, now it's safe to mark as having a file.

        _moviesWithFiles.add(movie.id);
      } else {
        debugPrint('Failed to save movie file: $result');
        throw Exception('WritePod failed with status: $result');
      }
    } catch (e) {
      // Don't log errors for normal file operations - reduces noise
      // debugPrint('Failed to create/update movie file for ${movie.id}: $e');
    }
  }

  /// Checks if a movie file exists (i.e., user has interacted with this movie).

  Future<bool> hasMovieFile(Movie movie) async {
    // First check our cache.

    if (_moviesWithFiles.contains(movie.id)) {
      return true;
    }

    // Try to read the file to see if it exists.

    final movieData = await _readMovieFile(movie);
    if (movieData != null) {
      final hasRating = movieData['rating'] != null;
      final hasComment = movieData['comment'] != null &&
          (movieData['comment'] as String?)?.isNotEmpty == true;

      if (hasRating || hasComment) {
        // Add to cache since we found the file exists.

        _moviesWithFiles.add(movie.id);

        // Also populate our data caches.

        if (hasRating && movieData['rating'] is double) {
          _cachedRatings ??= {};
          _cachedRatings![movie.id.toString()] = movieData['rating'] as double;
        }
        if (hasComment && movieData['comment'] is String) {
          _cachedComments ??= {};
          _cachedComments![movie.id.toString()] =
              movieData['comment'] as String;
        }

        return true;
      }
    }

    return false;
  }

  /// Gets the file path for a movie file (used for sharing).

  String getMovieFilePath(Movie movie) {
    return 'moviestar/data/movies/movie-${movie.id}.ttl';
  }

  /// Reads movie data from a single movie file.

  Future<Map<String, dynamic>?> _readMovieFile(Movie movie) async {
    try {
      final loggedIn = await isLoggedIn();
      if (!loggedIn) {
        return null;
      }

      // Use full path for readPod - different from writePod which uses relative path.

      final movieFileName = 'moviestar/data/movies/movie-${movie.id}.ttl';

      if (!_context.mounted) return null;
      final result = await readPod(movieFileName, _context, _child);

      if (result.isNotEmpty) {
        final movieData = TurtleSerializer.movieWithUserDataFromTurtle(result);
        return movieData;
      }
    } catch (e) {
      // Expected error for new movies - don't log to reduce noise.
    }
    return null;
  }

  /// Migrates data from SharedPreferences to POD.

  Future<void> migrateToPod() async {
    try {
      // Load data from SharedPreferences.

      final toWatch = await _fallbackService.getToWatch();
      final watched = await _fallbackService.getWatched();

      // Migrate ratings.

      final Map<String, double> ratings = {};
      for (final movie in [...toWatch, ...watched]) {
        final rating = await _fallbackService.getPersonalRating(movie);
        if (rating != null) {
          ratings[movie.id.toString()] = rating;
        }
      }

      // Migrate comments.

      final Map<String, String> comments = {};
      for (final movie in [...toWatch, ...watched]) {
        final comment = await _fallbackService.getMovieComments(movie);
        if (comment != null) {
          comments[movie.id.toString()] = comment;
        }
      }

      // Save to POD.

      await _saveToWatchToPod(toWatch);
      await _saveWatchedToPod(watched);
      await _saveRatingsToPod(ratings);
      // Skip saving comments to old format - we use individual movie files now
      // await _saveCommentsToPod(comments);
    } catch (e) {
      debugPrint('Failed to migrate data to POD: $e');
      rethrow;
    }
  }

  /// Syncs data between POD and local cache.

  Future<void> syncWithPod() async {
    await _loadFromPod();
  }

  /// Reloads data from POD after app folders are initialized.

  Future<void> reloadFromPod() async {
    try {
      final isPodReady = await isPodAvailable();
      if (isPodReady) {
        // Load data without triggering encryption key validation.

        await _loadFromPodWithoutKeyValidation();
      }
    } catch (e) {
      debugPrint('Failed to reload from POD: $e');
    }
  }

  /// Loads data from POD without triggering encryption key validation.
  /// This avoids the encryption key conflicts during initialization.

  Future<void> _loadFromPodWithoutKeyValidation() async {
    _isSyncing = true;

    try {
      // Initialize with empty data first.

      _cachedToWatch = [];
      _cachedWatched = [];
      _cachedRatings = {};
      _cachedComments = {};

      // Try to load each file individually without key validation.

      await _loadFileFromPodWithoutKey(_toWatchFileNameRead, (content) {
        if (content is String) {
          _cachedToWatch = TurtleSerializer.moviesFromTurtle(content);
        }
      });

      await _loadFileFromPodWithoutKey(_watchedFileNameRead, (content) {
        if (content is String) {
          _cachedWatched = TurtleSerializer.moviesFromTurtle(content);
        }
      });

      await _loadFileFromPodWithoutKey(_ratingsFileNameRead, (content) {
        if (content is String) {
          _cachedRatings = TurtleSerializer.ratingsFromTurtle(content);
        }
      });

      // Skip loading old comments file - we use individual movie files now.

      _cachedComments = {};

      // Update streams with POD data.

      _toWatchController.add(_cachedToWatch!);
      _watchedController.add(_cachedWatched!);
    } catch (e) {
      debugPrint('Error loading from POD: $e');
      // Initialize with empty data if POD fails.

      _cachedToWatch = [];
      _cachedWatched = [];
      _cachedRatings = {};
      _cachedComments = {};
    } finally {
      _isSyncing = false;
    }
  }

  /// Checks if POD storage is available and user is logged in.

  Future<bool> isPodAvailable() async {
    try {
      // Import the isLoggedIn function to check POD login status.
      // This is better than trying to read a non-existent file.

      final loggedIn = await isLoggedIn();
      return loggedIn;
    } catch (e) {
      debugPrint('POD availability check failed: $e');
      return false;
    }
  }

  /// Disposes the stream controllers.

  @override
  void dispose() {
    super.dispose();

    // Cancel any pending movie file updates to prevent memory leaks.

    for (final timer in _pendingMovieUpdates.values) {
      timer.cancel();
    }
    _pendingMovieUpdates.clear();

    _toWatchController.close();
    _watchedController.close();
    _fallbackService.dispose();
  }
}
